
const UserModel = require('../models/user.model')
const jwt = require('jsonwebtoken');
class UserService {
    static async registerUser(email, password) {
        try {
            UserModel.query(`INSERT INTO users_new(email,password) VALUES ($1, $2)`, [email, password], (err, res) => {
                if (!err) {
                    console.log("Inserted successfully");
                } else {
                    console.log(err.message);
                }
                UserModel.end;
            });
        }
        catch (err) {
            throw err;
        }
    }
    static async checkUser(email, password) {
        try {
            return new Promise((resolve, reject) => {
                const query = 'SELECT EXISTS (SELECT * FROM users_new WHERE email=$1 AND password=$2)';

                UserModel.query(query, [email, password], (err, res) => {
                    if (!err) {
                        if (res.rows[0]['exists']) {
                            console.log("Found user successfully");
                            resolve(true);
                        } else {
                            resolve(false); // User not found
                        }
                    } else {
                        resolve(false); 
                        console.error(err.message);
                        reject(err);
                    }

                    // Assuming you want to close the connection after the query
                    UserModel.end();
                });
            });
        } catch (err) {
            throw err;
        }
    }

    // static async checkUser(email, password) {
    //     try {
    //         UserModel.query(`SELECT EXISTS (SELECT * FROM users_new WHERE email=$1 AND password=$2)`, [email, password], (err, res) => {

    //             if (!err) {
    //                 if (res.rows[0]['exists']) {
    //                     console.log("Found user successfully");
    //                     return Promise.resolve(res.rows[0]['exists']);
    //                 }

    //             } else {
    //                 // isValid= false;
    //                 console.log(err.message);
    //             }
    //             UserModel.end;
    //         });
    //     }
    //     catch (err) {
    //         throw err;
    //     }
    // }
    static async generateToken(tokenData, secretKey, jwt_expire) {
        return jwt.sign(tokenData, secretKey, { expiresIn: jwt_expire });
    }
};
// UserService.checkUser("xyz@gmail.com","123456").res;
module.exports = UserService;