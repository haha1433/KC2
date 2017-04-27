package kr.co.koscom.marketdata.controller;

import java.io.IOException;
import java.net.URLEncoder;

import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import kr.co.koscom.marketdata.controller.urlCallController;
@RestController
public class indexController {
	
	@RequestMapping("/")
    public ModelAndView getListUsersView(
    		@RequestParam(value = "cate1", required = false, defaultValue = "001") String cate1,
    		@RequestParam(value = "sDate", required = false, defaultValue = "") String sDate,
    		@RequestParam(value = "sDate", required = false, defaultValue = "") String eDate) throws IOException, Exception {
		urlCallController url = new urlCallController();
        ModelMap model = new ModelMap();
        
		// 코드 리스트
		String allCodeLink = "https://sandbox-apigw.koscom.co.kr/v1/fabotdw/sector";
		String codeList = url.callUrl(allCodeLink);
		JSONObject codeListObj = new JSONObject(codeList);
		codeListObj = codeListObj.getJSONObject("result");
        model.addAttribute("codeList", codeListObj.get("data"));
        
       	// 코드값으로 종목 가져옴
       	String codeMarketLink = "https://sandbox-apigw.koscom.co.kr/v1/fabotdw/sector/{upcode}".replace("{upcode}", URLEncoder.encode(cate1, "UTF-8"));
       	String marketList = url.callUrl(codeMarketLink);
		JSONObject marketListObj = new JSONObject(marketList);
		marketListObj = marketListObj.getJSONObject("result");
		JSONArray arr = marketListObj.getJSONArray("data");
		for(int i=0; i<arr.length(); i++){
			// 종목의 과거값 가져오기
			JSONObject obj = arr.getJSONObject(i);
			String issuecode = obj.getString("stockcode");
			String pricesLink = "https://sandbox-apigw.koscom.co.kr/v1/wavelet/prices/{issuecode}?from=20170401&to=20170426&interval=1d".replace("{issuecode}", URLEncoder.encode(issuecode, "UTF-8"));
			String priceInfo = url.callUrl(pricesLink);
			JSONObject priceInfoObj = new JSONObject(priceInfo);
			JSONArray arr2 = priceInfoObj.getJSONArray("data");
			JSONObject tmp = arr2.getJSONObject(0);
			arr2 = tmp.getJSONArray("points");
			JSONObject obj2 = arr2.getJSONObject(0);
			int sPrice = obj2.getInt("close");
			obj2 = arr2.getJSONObject(arr2.length() - 1);
			int ePrice = obj2.getInt("close");
			obj.put("difPrice", sPrice - ePrice);
		}
        model.addAttribute("marketList", marketListObj.get("data"));
        
        System.out.println(cate1);
        System.out.println(sDate);
        System.out.println(eDate);
        
        model.addAttribute("cate1", cate1);
        model.addAttribute("sdate", sDate);
        model.addAttribute("edate", eDate);
        return new ModelAndView("index", model);
    }
}
