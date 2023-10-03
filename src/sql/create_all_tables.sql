CREATE TABLE "Role" (
                        "RoleID" SERIAL PRIMARY KEY,
                        "RoleName" VARCHAR(255) UNIQUE,
                        "CreatedAt" TIMESTAMP DEFAULT NOW(),
                        "DeletedAt" TIMESTAMP
);

INSERT INTO "Role" ("RoleName")
VALUES ('Parent'), ('Teacher'), ('Sports Coach'), ('Kitchen Manager'), ('Aftercare Manager'), ('Superadmin');

CREATE TABLE "User" (
                        "UserID" SERIAL PRIMARY KEY,
                        "FirstName" VARCHAR(255),
                        "LastName" VARCHAR(255),
                        "Email" VARCHAR(255) UNIQUE,
                        "Password" VARCHAR(255),
                        "ContactNumber" VARCHAR(20),
                        "Address" TEXT,
                        "CreatedAt" TIMESTAMP DEFAULT NOW(),
                        "DeletedAt" TIMESTAMP
);

CREATE TABLE "UserRole" (
                            "UserID" INT,
                            "RoleID" INT,
                            "CreatedAt" TIMESTAMP DEFAULT NOW(),
                            "DeletedAt" TIMESTAMP
);

CREATE TABLE "Class" (
                         "ClassID" SERIAL PRIMARY KEY,
                         "ClassName" VARCHAR(255),
                         "Grade" INT CHECK ("Class"."Grade" >= 0 AND "Class"."Grade" <= 12),
                         "LeadTeacherID" INT,
                         "CreatedAt" TIMESTAMP DEFAULT NOW(),
                         "DeletedAt" TIMESTAMP
);

CREATE TABLE "Student" (
                           "StudentID" SERIAL PRIMARY KEY,
                           "FirstName" VARCHAR(255),
                           "LastName" VARCHAR(255),
                           "DateOfBirth" DATE,
                           "ContactNumber" VARCHAR(20),
                           "Address" TEXT,
                           "ParentID" INT,
                           "ClassID" INT,
                           "CreatedAt" TIMESTAMP DEFAULT NOW(),
                           "DeletedAt" TIMESTAMP
);

CREATE TABLE "Attendance" (
                              "AttendanceID" SERIAL PRIMARY KEY,
                              "StudentID" INT,
                              "AttendanceDate" DATE,
                              "CheckInTime" TIME,
                              "CheckOutTime" TIME,
                              "AdditionalRequirements" TEXT,
                              "CreatedAt" TIMESTAMP DEFAULT NOW(),
                              "DeletedAt" TIMESTAMP
);

CREATE TABLE "Meal" (
                        "MealID" SERIAL PRIMARY KEY,
                        "MealName" VARCHAR(255),
                        "Description" TEXT,
                        "NutritionalInformation" TEXT,
                        "Cost" DECIMAL(10, 2),
                        "CreatedAt" TIMESTAMP DEFAULT NOW(),
                        "DeletedAt" TIMESTAMP
);

CREATE TABLE "Activity" (
                            "ActivityID" SERIAL PRIMARY KEY,
                            "ActivityName" VARCHAR(255),
                            "Description" TEXT,
                            "StartTime" TIME,
                            "EndTime" TIME,
                            "CreatedAt" TIMESTAMP DEFAULT NOW(),
                            "DeletedAt" TIMESTAMP
);

CREATE TABLE "Invoice" (
                           "InvoiceID" SERIAL PRIMARY KEY,
                           "ParentID" INT,
                           "TotalAmount" DECIMAL(10, 2),
                           "InvoiceDate" DATE,
                           "DueDate" DATE,
                           "Status" VARCHAR(255),
                           "CreatedAt" TIMESTAMP DEFAULT NOW(),
                           "DeletedAt" TIMESTAMP
);

CREATE TABLE "Notification" (
                                "NotificationID" SERIAL PRIMARY KEY,
                                "UserID" INT,
                                "Message" TEXT,
                                "NotificationTime" TIMESTAMP,
                                "Status" VARCHAR(255),
                                "CreatedAt" TIMESTAMP DEFAULT NOW(),
                                "DeletedAt" TIMESTAMP
);

CREATE TABLE "CheckInOut" (
                              "CheckID" SERIAL PRIMARY KEY,
                              "StudentID" INT,
                              "CheckInTime" TIME,
                              "CheckOutTime" TIME,
                              "Date" DATE,
                              "CreatedAt" TIMESTAMP DEFAULT NOW(),
                              "DeletedAt" TIMESTAMP
);

CREATE TABLE "StudentMeal" (
                               "StudentMealID" SERIAL PRIMARY KEY,
                               "StudentID" INT,
                               "MealID" INT,
                               "MealDate" DATE,
                               "CreatedAt" TIMESTAMP DEFAULT NOW(),
                               "DeletedAt" TIMESTAMP
);

CREATE TABLE "StudentActivity" (
                                   "StudentActivityID" SERIAL PRIMARY KEY,
                                   "StudentID" INT,
                                   "ActivityID" INT,
                                   "ActivityDate" DATE,
                                   "CreatedAt" TIMESTAMP DEFAULT NOW(),
                                   "DeletedAt" TIMESTAMP
);

CREATE TABLE "Message" (
                           "MessageID" SERIAL PRIMARY KEY,
                           "StudentID" INT,
                           "UserID" INT,
                           "Content" TEXT,
                           "CreatedAt" TIMESTAMP DEFAULT NOW(),
                           "DeletedAt" TIMESTAMP
);

ALTER TABLE "Class"
    ADD CONSTRAINT FK_User_Class
        FOREIGN KEY ("LeadTeacherID")
            REFERENCES "User"("UserID");

ALTER TABLE "Student"
    ADD CONSTRAINT FK_User_Student
        FOREIGN KEY ("ParentID")
            REFERENCES "User"("UserID");

ALTER TABLE "Student"
    ADD CONSTRAINT FK_Class_Student
        FOREIGN KEY ("ClassID")
            REFERENCES "Class"("ClassID");

ALTER TABLE "UserRole"
    ADD CONSTRAINT FK_User_UserRole
        FOREIGN KEY ("UserID")
            REFERENCES "User"("UserID");

ALTER TABLE "UserRole"
    ADD CONSTRAINT FK_Role_UserRole
        FOREIGN KEY ("RoleID")
            REFERENCES "Role"("RoleID");

ALTER TABLE "Attendance"
    ADD CONSTRAINT FK_Student_Attendance
        FOREIGN KEY ("StudentID")
            REFERENCES "Student"("StudentID");

ALTER TABLE "Invoice"
    ADD CONSTRAINT FK_User_Invoice
        FOREIGN KEY ("ParentID")
            REFERENCES "User"("UserID");

ALTER TABLE "Notification"
    ADD CONSTRAINT FK_User_Notification
        FOREIGN KEY ("UserID")
            REFERENCES "User"("UserID");

ALTER TABLE "CheckInOut"
    ADD CONSTRAINT FK_Student_CheckInOut
        FOREIGN KEY ("StudentID")
            REFERENCES "Student"("StudentID");

ALTER TABLE "StudentMeal"
    ADD CONSTRAINT FK_Student_StudentMeal
        FOREIGN KEY ("StudentID")
            REFERENCES "Student"("StudentID");

ALTER TABLE "StudentMeal"
    ADD CONSTRAINT FK_Meal_StudentMeal
        FOREIGN KEY ("MealID")
            REFERENCES "Meal"("MealID");

ALTER TABLE "StudentActivity"
    ADD CONSTRAINT FK_Student_StudentActivity
        FOREIGN KEY ("StudentID")
            REFERENCES "Student"("StudentID");

ALTER TABLE "StudentActivity"
    ADD CONSTRAINT FK_Activity_StudentActivity
        FOREIGN KEY ("ActivityID")
            REFERENCES "Activity"("ActivityID");

ALTER TABLE "Message"
    ADD CONSTRAINT FK_Student_Message
        FOREIGN KEY ("StudentID")
            REFERENCES "Student"("StudentID");

ALTER TABLE "Message"
    ADD CONSTRAINT FK_User_Message
        FOREIGN KEY ("UserID")
            REFERENCES "User"("UserID");