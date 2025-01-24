# 🕶️ **Shinobi Expenses**

A smart expense tracker with intuitive visualizations!  

## 📖 **Overview**  

**Shinobi Expenses** is a Flutter-based expense tracking app designed to provide users with an efficient way to manage their finances.  
With **local storage**, **visual insights**, and **detailed categorization**, the app is your go-to solution for understanding and controlling expenses.  

## **Features**

### 💵 **Expense Tracking**:  
- 🖊️ Add expenses with fields for **amount**, **date**, **description**, and **category**.  
- 🗂️ Predefined categories:  
  - `Food`, `Snacks`, `Travel`, `Daily Goods`, `PG Rent`, `Miscellaneous`.  

### 📊 **Visual Insights**:  
- 🥧 **Pie Chart**: Displays **category-wise expense distribution**.  
- 📈 **Line Chart**:  
  - 📉 **Cumulative expenses** over time.  
  - 📆 **Daily expenses**.  

### 💾 **Local Data Storage**:  
- 📦 Uses **SharedPreferences** to store and retrieve expense data locally.  
- 🌐 **No internet connection required**.  

### 📋 **Summaries**:  
- 💰 **Total expenses**.  
- 📊 **Category-wise expense breakdown**.  

### 🖥️ **User-Friendly Interface**:  
- ✨ **Intuitive and minimalistic UI**.  
- 🚀 **Easy navigation** to add, view, and analyze expenses.  

## **Technologies Used**

- 🎨 **Frontend**: Flutter (Dart)  
- 🗂️ **State Management**: SetState  
- 💾 **Local Storage**: SharedPreferences  
- 📊 **Charts/Visualizations**:  
  - 🥧 **Pie Chart**: fl_chart  
  - 📈 **Line Chart**: syncfusion_flutter_charts  


## **Requirements**

### 🔧 **Software Prerequisites**
- 🚀 **Flutter SDK**: Install from [Flutter's official website](https://flutter.dev/docs/get-started/install).
- 🎯 **Dart SDK**: Comes bundled with Flutter.
- 💻 **IDE**: Android Studio, VS Code, or any Flutter-compatible IDE.
- 📱 **Emulator/Device**: Android.



## 🚀 **Installation and Setup**

Follow these steps to get **Shinobi Expenses** running on your system:

### 1️⃣ **Clone the Repository**
Clone the project to your local machine:  
```bash
git clone https://github.com/Ritesh-K-G/expense-tracker-mobile.git
cd expense-tracker-mobile
```
### 2️⃣ **Install Dependencies**
Run the following command in your terminal to install all the required Flutter packages:  
```bash
flutter pub get
```
### 3️⃣ **Run the App**

#### On an Emulator:  
- Start an **Android Emulator** or an **iOS Simulator**.  
- Once the emulator is running, execute:  
  ```bash
  flutter run
  ```

## **Usage**  

### 📝 **Add Expenses**  
- ➕ Tap the **"+" button**.  
- 🖊️ Fill in details:  
  - **Amount**, **Date**, **Description**, and **Category**.  
- 💾 Save the expense.  

### 📋 **View Expenses**  
- 👁️ Access the **list of all expenses**.  
- 📊 Check:  
  - **Total expenses**.  
  - **Category-wise breakdown**.  

### 📈 **Visualizations**  
- 🥧 **Pie chart**: View **percentage distribution** across categories.  
- 📉 **Line chart**: Analyze:  
  - **Cumulative expenses** over time.  
  - **Daily expenses** trends.

 
## Screenshots

<table>
  <tr>
    <td>
      <img src="https://github.com/user-attachments/assets/ceec7769-1f3a-4f21-a7f4-22352c8e7e50" alt="Screenshot 1" width="250">
    </td>
    <td>
      <img src="https://github.com/user-attachments/assets/446786d7-942f-4543-b4db-9dafb2513ebd" alt="Screenshot 2" width="250">
    </td>
    <td>
      <img src="https://github.com/user-attachments/assets/0be949e5-15f9-445f-8e88-8d6cf0a36bd9" alt="Screenshot 3" width="250">
    </td>
    <td>
      <img src="https://github.com/user-attachments/assets/e77fb733-1cdc-4712-a946-134ffb808550" alt="Screenshot 4" width="250">
    </td>
  </tr>
</table>

## 🤝 **Contributing**

We welcome contributions! If you'd like to help improve **Shinobi Expenses**, follow the steps below:

### 1️⃣ **Fork the Repository**  
- Click the **Fork** button at the top-right of this page to create a personal copy of this repository.

### 2️⃣ **Clone the Forked Repository**  
- Clone your fork to your local machine:  
  ```bash
  git clone https://github.com/Ritesh-K-G/expense-tracker-mobile.git
  cd expense-tracker-mobile
  ```
### 3️⃣ **Create a New Branch**
- Create a new branch for your changes
  ```bash
  git checkout -b feature/your-feature-name
  ```
### 4️⃣ **Make Your Changes**
- Implement your changes or bug fixes in the appropriate files.
### 5️⃣ **Commit Your Changes**
- Once you're happy with your changes, commit them:
  ```bash
  git commit -m "Add a brief message describing your changes"
  ```
### 6️⃣ **Push to Your Fork**
- Push your changes back to your fork on GitHub:
  ```bash
  git push origin feature/your-feature-name
  ```
### 7️⃣ **Create a Pull Request**
- Go to the repository on GitHub and click the New Pull Request button.
- Choose your branch and create the pull request with a detailed description of the changes.

Thank you for contributing! 🎉
