/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/UnitTests/JUnit5TestClass.java to edit this template
 */
package org.nanoboot.assetmanager.entity;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.AfterAll;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;
import org.nanoboot.powerframework.time.moment.LocalDate;
import org.nanoboot.powerframework.time.moment.LocalDateTime;

/**
 *
 * @author robertvokac
 */
public class AssetTest {
    
    public AssetTest() {
    }
    
  
    /**
     * Test of getPriceAsString method, of class Asset.
     */
    @Test
    public void testGetPriceAsString() {
        System.out.println("getPriceAsString");
        Asset instance = new Asset();
        instance.setPriceValue(123456l);
        String expResult = "1234.56";
        String result = instance.getPriceAsString();
        assertEquals(expResult, result);
    }
    
        
  
    /**
     * Test of getPriceAsString method, of class Asset.
     */
    @Test
    public void testGetPriceAsString2() {
        System.out.println("getPriceAsString");
        Asset instance = new Asset();
        instance.setPriceValue(123450l);
        String expResult = "1234.50";
        String result = instance.getPriceAsString();
        assertEquals(expResult, result);
    } 
  
    /**
     * Test of getPriceAsString method, of class Asset.
     */
    @Test
    public void testGetPriceAsString3() {
        System.out.println("getPriceAsString");
        Asset instance = new Asset();
        instance.setPriceValue(123400l);
        String expResult = "1234.00";
        String result = instance.getPriceAsString();
        assertEquals(expResult, result);
    }

    /**
     * Test of convertPriceStringToPriceLong method, of class Asset.
     */
    @Test
    public void testConvertPriceStringToPriceLong() {
        System.out.println("convertPriceStringToPriceLong");
        String priceString = "1234.56";
        Long expResult = 123456l;
        Long result = Asset.convertPriceStringToPriceLong(priceString);
        assertEquals(expResult, result);
    }

    /**
     * Test of convertPriceStringToPriceLong method, of class Asset.
     */
    @Test
    public void testConvertPriceStringToPriceLong2() {
        System.out.println("convertPriceStringToPriceLong");
        String priceString = "1234.50";
        Long expResult = 123450l;
        Long result = Asset.convertPriceStringToPriceLong(priceString);
        assertEquals(expResult, result);
    }
    /**
     * Test of convertPriceStringToPriceLong method, of class Asset.
     */
    @Test
    public void testConvertPriceStringToPriceLong3() {
        System.out.println("convertPriceStringToPriceLong");
        String priceString = "1234";
        Long expResult = 123400l;
        Long result = Asset.convertPriceStringToPriceLong(priceString);
        assertEquals(expResult, result);
    }
  
}
