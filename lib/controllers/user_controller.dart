import '../apis/user_api.dart';
import '../Model/user_model.dart'; // Adjust the import based on your file structure

class UserController {
  List<User> users = []; // Change the type to List<User>

  Future<bool> fetchUsers() async {
    final userApi = UserApi();
    try {
      final response = await userApi.getAllUsers();
      if (response.statusCode == 200) {
        users = (response.data as List)
            .map((userJson) => User.fromJson(userJson))
            .toList(); // Parse the user data
        return true;
      } else {
        print('Failed to fetch users: ${response.data}');
        return false;
      }
    } catch (e) {
      print('Error occurred: $e');
      return false;
    }
  }
}
