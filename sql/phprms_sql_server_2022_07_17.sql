USE [master]
GO

/****** Object:  Database [phprms]    Script Date: 07/17/2022 10:55:17 ******/
CREATE DATABASE [phprms] ON  PRIMARY 
( NAME = N'phprms', FILENAME = N'd:\MSSQL\DATA\phprms.mdf' , SIZE = 4096KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'phprms_log', FILENAME = N'd:\MSSQL\DATA\phprms_log.ldf' , SIZE = 4224KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO

ALTER DATABASE [phprms] SET COMPATIBILITY_LEVEL = 100
GO

IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [phprms].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO

ALTER DATABASE [phprms] SET ANSI_NULL_DEFAULT OFF 
GO

ALTER DATABASE [phprms] SET ANSI_NULLS OFF 
GO

ALTER DATABASE [phprms] SET ANSI_PADDING OFF 
GO

ALTER DATABASE [phprms] SET ANSI_WARNINGS OFF 
GO

ALTER DATABASE [phprms] SET ARITHABORT OFF 
GO

ALTER DATABASE [phprms] SET AUTO_CLOSE OFF 
GO

ALTER DATABASE [phprms] SET AUTO_CREATE_STATISTICS ON 
GO

ALTER DATABASE [phprms] SET AUTO_SHRINK OFF 
GO

ALTER DATABASE [phprms] SET AUTO_UPDATE_STATISTICS ON 
GO

ALTER DATABASE [phprms] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO

ALTER DATABASE [phprms] SET CURSOR_DEFAULT  GLOBAL 
GO

ALTER DATABASE [phprms] SET CONCAT_NULL_YIELDS_NULL OFF 
GO

ALTER DATABASE [phprms] SET NUMERIC_ROUNDABORT OFF 
GO

ALTER DATABASE [phprms] SET QUOTED_IDENTIFIER OFF 
GO

ALTER DATABASE [phprms] SET RECURSIVE_TRIGGERS OFF 
GO

ALTER DATABASE [phprms] SET  DISABLE_BROKER 
GO

ALTER DATABASE [phprms] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO

ALTER DATABASE [phprms] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO

ALTER DATABASE [phprms] SET TRUSTWORTHY OFF 
GO

ALTER DATABASE [phprms] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO

ALTER DATABASE [phprms] SET PARAMETERIZATION SIMPLE 
GO

ALTER DATABASE [phprms] SET READ_COMMITTED_SNAPSHOT OFF 
GO

ALTER DATABASE [phprms] SET HONOR_BROKER_PRIORITY OFF 
GO

ALTER DATABASE [phprms] SET  READ_WRITE 
GO

ALTER DATABASE [phprms] SET RECOVERY FULL 
GO

ALTER DATABASE [phprms] SET  MULTI_USER 
GO

ALTER DATABASE [phprms] SET PAGE_VERIFY CHECKSUM  
GO

ALTER DATABASE [phprms] SET DB_CHAINING OFF 
GO

