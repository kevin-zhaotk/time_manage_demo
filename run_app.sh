#!/bin/bash

# 日历转换Flutter App启动脚本

echo "🚀 启动日历转换Flutter应用..."

# 检查Flutter环境
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter未安装，请先安装Flutter SDK"
    echo "📖 安装指南: https://flutter.dev/docs/get-started/install"
    exit 1
fi

# 检查Flutter版本
echo "📱 检查Flutter版本..."
flutter --version

# 安装依赖
echo "📦 安装项目依赖..."
flutter pub get

# 检查可用设备
echo "📱 检查可用设备..."
flutter devices

# 提示用户选择运行方式
echo ""
echo "🎯 选择运行方式:"
echo "1. iOS模拟器 (需要macOS)"
echo "2. Android模拟器"
echo "3. Chrome浏览器 (Web版)"
echo "4. 自动检测设备"
echo ""

read -p "请输入选择 (1-4): " choice

case $choice in
    1)
        echo "🍎 启动iOS版本..."
        flutter run -d ios
        ;;
    2)
        echo "🤖 启动Android版本..."
        flutter run -d android
        ;;
    3)
        echo "🌐 启动Web版本..."
        flutter run -d chrome
        ;;
    4)
        echo "🔍 自动检测设备..."
        flutter run
        ;;
    *)
        echo "❌ 无效选择，使用自动检测..."
        flutter run
        ;;
esac