const crypto = require('crypto');

// Clave y vector de inicialización (IV)
const key = crypto.randomBytes(32); // Clave de 256 bits
const iv = crypto.randomBytes(16);  // IV de 128 bits

// Función para cifrar
function encrypt(text) {
    let cipher = crypto.createCipheriv('aes-256-cbc', Buffer.from(key), iv);
    let encrypted = cipher.update(text);
    encrypted = Buffer.concat([encrypted, cipher.final()]);
    return { iv: iv.toString('hex'), encryptedData: encrypted.toString('hex') };
}

// Texto a cifrar
const text = "AB12$$ab";
const encrypted = encrypt(text);

console.log("Texto cifrado:", encrypted);
console.log("Clave (hex):", key.toString('hex'));

