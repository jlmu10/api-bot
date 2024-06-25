const crypto = require('crypto');

// Clave y IV deben ser los mismos que se usaron para cifrar
const key = Buffer.from('tu_clave_en_hex', 'hex');
const iv = Buffer.from('tu_iv_en_hex', 'hex');

// Función para descifrar
function decrypt(text) {
    let encryptedText = Buffer.from(text, 'hex');
    let decipher = crypto.createDecipheriv('aes-256-cbc', Buffer.from(key), iv);
    let decrypted = decipher.update(encryptedText);
    decrypted = Buffer.concat([decrypted, decipher.final()]);
    return decrypted.toString();
}

// Texto cifrado (hex)
const encryptedText = 'tu_texto_cifrado_en_hex';
const decrypted = decrypt(encryptedText);

console.log("Texto descifrado:", decrypted);
