package com.example.demo;

import com.example.demo.Weather;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;


@FeignClient("weather-service")
@RequestMapping("/weather")
public interface WeatherServiceClient{

    @GetMapping("/city")
    Weather getWeatherForCity(@RequestParam("name") String cityName);
}

