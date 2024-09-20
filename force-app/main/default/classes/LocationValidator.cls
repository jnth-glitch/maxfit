public with sharing class LocationValidator {
    public static void VerifyLocation(List<Location__c> locList){
        for(Location__c loc: locList){
            try{
                LocationValidator.ValidateLocation(loc.Name, loc.Street__c, loc.City__c, loc.State__c, loc.Postal_Code__c, loc.Country__c);
                loc.Verified__c = true;
            }

            catch(Exception e){
                loc.addError('Enter valid address');
            }
        }
        }

    @future (callout=true)
    public static void ValidateLocation(String name,String street,String city,String state,String postalCode,String country){
        Http http = new Http();

        HttpRequest request = new HttpRequest();
        
        request.setMethod('GET');

        Location_Validator__mdt loc = Location_Validator__mdt.getInstance('locations');
        System.debug(loc);

        String url = loc.Endpoint__c+'&street='+removeSpaces(street)+'&city='+removeSpaces(city)+'&state='+removeSpaces(state)+'&zipcode='+removeSpaces(postalCode)+'&candidates=10&match=enhanced&auth-id='+loc.Auth_ID__c+'&auth-token='+loc.auth_token__c;
        System.debug(url);
        request.setEndpoint(url);
        try {
            HttpResponse response = http.send(request);
            System.debug(response.getStatusCode());
            System.debug(response.getBody());

            if(response.getStatusCode()==200){
                List<LocationParser> formattedLocation = LocationParser.parse(response.getBody());
                if(formattedLocation.size()<=0){
                    throw new IllegalArgumentException('Any exception related text');
                }
            }
        } catch (Exception e) {
            System.debug(e.getMessage());
            throw new IllegalArgumentException('Any exception related text');
        }

    }


    public static String removeSpaces(String s){
        return s.replaceAll(' ', '%20');
    }
   
}