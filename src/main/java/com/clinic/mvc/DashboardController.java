package com.clinic.mvc;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

@Controller
public class DashboardController {

    @GetMapping("/adminDashboard/{token}")
    public String admin(@PathVariable String token) {
        return "admin/adminDashboard";
    }

    @GetMapping("/doctorDashboard/{token}")
    public String doctor(@PathVariable String token) {
        return "doctor/doctorDashboard";
    }
}