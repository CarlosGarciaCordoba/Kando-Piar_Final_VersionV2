import { google } from 'googleapis';
import path from 'path';
import fs from 'fs';

// En Node.js/TypeScript, __dirname ya está disponible

const SCOPES = ['https://www.googleapis.com/auth/gmail.send'];
const CREDENTIALS_PATH = path.join(__dirname, '../../credentials.json');
const TOKEN_PATH = path.join(__dirname, '../../token.json');

function loadCredentials() {
	const content = fs.readFileSync(CREDENTIALS_PATH, 'utf8');
	return JSON.parse(content);
}

async function main() {
	const credentials = loadCredentials();
	const { client_secret, client_id, redirect_uris } = credentials.installed;
	const oAuth2Client = new google.auth.OAuth2(client_id, client_secret, redirect_uris[0]);

	const authUrl = oAuth2Client.generateAuthUrl({
		access_type: 'offline',
		scope: SCOPES,
	});
	console.log('Autoriza esta app visitando esta URL:', authUrl);

	// Leer el código de la terminal
	import('readline').then((readlineModule) => {
		const readline = readlineModule.createInterface({
			input: process.stdin,
			output: process.stdout,
		});
		readline.question('Introduce el código de autorización: ', async (code) => {
			try {
				const { tokens } = await oAuth2Client.getToken(code);
				oAuth2Client.setCredentials(tokens);
				fs.writeFileSync(TOKEN_PATH, JSON.stringify(tokens));
				console.log('Token guardado en', TOKEN_PATH);
			} catch (err) {
				console.error('Error al guardar el token:', err);
			}
			readline.close();
		});
	});
}

main();