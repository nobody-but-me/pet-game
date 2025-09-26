
import path from 'path'
import { app, Tray, Menu } from 'electron'
import serve from 'electron-serve'
import { createWindow } from './helpers'

const WIN_WIDTH = 400;
const WIN_HEIGHT = WIN_WIDTH/9*16;

const isProd = process.env.NODE_ENV === 'production'
let tray = null;

if (isProd) {
    serve({ directory: 'app' })
} else {
    app.setPath('userData', `${app.getPath('userData')} (development)`)
}

;(async () => {
    app.disableHardwareAcceleration();
    await app.whenReady();
    
    const mainWindow = createWindow('main', {
	width: WIN_WIDTH,
	height: WIN_HEIGHT,
	webPreferences: {
	    preload: path.join(__dirname, 'preload.js'),
	    devTools: false,
	},
	resizable: false,
    })
    
    if (isProd) {
	await mainWindow.loadURL('app://./home')
    } else {
	const port = process.argv[2]
	await mainWindow.loadURL(`http://localhost:${port}/home`)
	mainWindow.webContents.openDevTools()
    }
    
    tray = new Tray('renderer/public/images/egg-icon.png');
    const content_menu = Menu.buildFromTemplate([
	{ label: 'Exit', role: 'quit' }
    ]);
    tray.setContextMenu(content_menu);
    tray.setToolTip('Pet game');
    
})();

app.on('window-all-closed', () => {
    // app.quit()
    if (process.platform === 'darwin') app.dock.hide();
});

