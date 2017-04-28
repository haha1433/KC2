package kr.co.koscom.marketdata.controller;

import java.io.IOException;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.Calendar;

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
	
	String codeLinkTpl = "https://sandbox-apigw.koscom.co.kr/v1/fabotdw/sector";
	String marketByCodeLinkTpl = "https://sandbox-apigw.koscom.co.kr/v1/fabotdw/sector/{upcode}";
	String priceByIssuecodeTpl = "https://sandbox-apigw.koscom.co.kr/v1/wavelet/prices/{issuecode}";
	
	@RequestMapping("/")
    public ModelAndView getListUsersView(
    		@RequestParam(value = "cate1", required = false, defaultValue = "022") String cate1,
    		@RequestParam(value = "sDate", required = false, defaultValue = "20170401") String sDate,
    		@RequestParam(value = "eDate", required = false, defaultValue = "20170427") String eDate) throws IOException, Exception {
		urlCallController url = new urlCallController();
        ModelMap model = new ModelMap();
        
		// 코드 리스트
		String codeList = url.callUrl(codeLinkTpl);
		JSONObject codeListObj = new JSONObject(codeList);
		codeListObj = codeListObj.getJSONObject("result");
        model.addAttribute("codeList", codeListObj.get("data"));
        
       	// 코드값으로 종목 가져옴
       	String marketByCodeLink = marketByCodeLinkTpl.replace("{upcode}", URLEncoder.encode(cate1, "UTF-8"));
       	String marketList = url.callUrl(marketByCodeLink);
		JSONObject marketListObj = new JSONObject(marketList);
		marketListObj = marketListObj.getJSONObject("result");
		JSONArray marketListArr = marketListObj.getJSONArray("data");
		for(int i=0; i<marketListArr.length(); i++){
			// 종목의 과거값 가져오기
			JSONObject obj = marketListArr.getJSONObject(i);
			String issuecode = obj.getString("stockcode");
			String pricesByIssuecodeLink = priceByIssuecodeTpl.replace("{issuecode}", URLEncoder.encode(issuecode, "UTF-8"));
			if(!sDate.equals("") && !eDate.equals("")){	// 날짜 입력 받았을때
				pricesByIssuecodeLink += "?interval=1d&from="+sDate+"&to="+eDate;
			}
			System.out.println(pricesByIssuecodeLink); // 디버깅용
			String priceInfo = url.callUrl(pricesByIssuecodeLink);
			JSONObject priceInfoObj = new JSONObject(priceInfo);
			JSONArray priceInfoArr = priceInfoObj.getJSONArray("data");
			// 과거의 첫번째 값, 마지막 값 가져오기
			int sPrice = 0;
			int ePrice = 0;
			if(priceInfoArr.length() > 0){
				priceInfoObj = priceInfoArr.getJSONObject(0);
				priceInfoArr = priceInfoObj.getJSONArray("points");
				JSONObject priceInfoStartObj = priceInfoArr.getJSONObject(0);
				sPrice = priceInfoStartObj.getInt("close");
				JSONObject priceInfoEndObj = priceInfoArr.getJSONObject(priceInfoArr.length() - 1);
				ePrice = priceInfoEndObj.getInt("close");
			}
			obj.put("difPrice", ePrice - sPrice);
		}
        model.addAttribute("marketList", marketListObj.get("data"));
        model.addAttribute("cate1", cate1);
        model.addAttribute("sdate", sDate);
        model.addAttribute("edate", eDate);
        return new ModelAndView("index", model);
    }
	
	// 그래프 데이터 가져오기
	@RequestMapping("/data.csv")
	public ModelAndView getChartData(
    		@RequestParam(value = "issuecode", required = true) String issuecode,
    		@RequestParam(value = "sDate", required = true) String sDate,
    		@RequestParam(value = "eDate", required = true) String eDate) throws IOException, Exception {
		urlCallController url = new urlCallController();
        ModelMap model = new ModelMap();
        
        String pricesByIssuecodeLink = priceByIssuecodeTpl.replace("{issuecode}", URLEncoder.encode(issuecode, "UTF-8"));
		if(!sDate.equals("") && !eDate.equals("")){
			pricesByIssuecodeLink += "?interval=1d&from="+sDate+"&to="+eDate;
		}
		String priceInfo = url.callUrl(pricesByIssuecodeLink);
		JSONObject priceInfoObj = new JSONObject(priceInfo);
		JSONArray priceInfoArr = priceInfoObj.getJSONArray("data");
		int sPrice = 0;
		int ePrice = 0;
		if(priceInfoArr.length() > 0){
			priceInfoObj = priceInfoArr.getJSONObject(0);
			priceInfoArr = priceInfoObj.getJSONArray("points");
			JSONObject priceInfoStartObj = priceInfoArr.getJSONObject(0);
			sPrice = priceInfoStartObj.getInt("close");
			JSONObject priceInfoEndObj = priceInfoArr.getJSONObject(priceInfoArr.length() - 1);
			ePrice = priceInfoEndObj.getInt("close");
		}
		
		model.addAttribute("sDate", sDate);
		model.addAttribute("eDate", eDate);
		model.addAttribute("sPrice", sPrice);
		model.addAttribute("ePrice", ePrice);
        return new ModelAndView("data", model);
	}
}
