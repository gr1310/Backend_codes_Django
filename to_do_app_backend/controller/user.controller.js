const UserService = require("../services/user.services");

exports.register = async (req, res, next) => {
    try {
        const { email, password } = req.body;
        console.log(req.body);
        // const successRes= await 
        UserService.registerUser(email, password);

        res.json({ status: true, success: "User Registered Successfully" })
    } catch (error) {
        throw error
    }
}

// exports.login = async (req, res, next) => {
//     try {
//         const { email, password } = req.body;
//         console.log(req.body);
//         let isValid = false;
//         UserService.checkUser(email, password)
//             .then(found => {
//                 if (found) {
//                     console.log('User found.');
//                     isValid = true;
//                     let toeknData = { email: email };

//                     const token = await UserService.generateToken(toeknData, "secretkey", "1h");
//                     res.status(200).json({ status: true, token: token });

//                     res.json({ status: true, success: "User Found Successfully" })
//                 } else {
//                     console.log('User not found.');
//                 }
//             })
//             .catch(error => console.error('Error checking user:', error));
//         // console.log(isValid);
//         // if(isValid==false){
//         //     throw new Error("Invalid Credentials");
//         // }
//         let toeknData = { email: email };

//         const token = await UserService.generateToken(toeknData, "secretkey", "1h");
//         res.status(200).json({ status: true, token: token });

//         res.json({ status: true, success: "User Found Successfully" })
//     } catch (error) {
//         throw error
//     }
// }

exports.login = async (req, res, next) => {
    try {
        const { email, password } = req.body;
        console.log(req.body);

        const found = await UserService.checkUser(email, password);

        if (found) {
            console.log('User found.');
            const tokenData = { email: email };

            const token = await UserService.generateToken(tokenData, "secretkey", "1h");
            res.status(200).json({ status: true, token: token, success: "User Found Successfully" });
        } else {
            console.log('User not found.');
            res.status(401).json({ status: false, error: "User not found or invalid credentials" });
        }
    } catch (error) {
        console.error('Error checking user:', error);
        res.status(500).json({ status: false, error: "Internal Server Error" });
    }
};
