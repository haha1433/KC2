package kr.co.koscom.marketdata.controller;

import java.io.IOException;

import org.json.JSONObject;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import kr.co.koscom.marketdata.controller.urlCallController;
@RestController
public class indexController {
	
	@RequestMapping("/")
    public ModelAndView getListUsersView() throws IOException, Exception {
		urlCallController url = new urlCallController();
		String marketList = url.callUrl();
		JSONObject jsonObject = new JSONObject(marketList);
        ModelMap model = new ModelMap();
        model.addAttribute("marketList", jsonObject.get("isuLists"));
        return new ModelAndView("index", model);
    }
}
