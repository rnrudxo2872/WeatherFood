import { getPosition } from './main/src/getPosition.js';

let init = async () => {
    let PosObj = await getPosition();
    var params = `lat=${PosObj.lat}&lon=${PosObj.lon}`; //쿼리, 데이터 넘긴다
    console.log("날씨여기")
    console.log(params);
    $.ajax({
        type: "POST", //전송방식
        url: "/MyFirstJSP/weatherData.xml", //주소
        data: params, //전송데이터
        dataType: "xml", // 받을 때 데이터 타입

        // xml 형태의 데이터 args
        success: function (args) {

            // xml 형태 parsing
            let weatherList = [];
            //장소, 온도, 날씨
            $(args).find("status").each(function () { //status 해당 태그 검색. eaxh는 반복문
                weatherList.push($(this).text());
            });

            console.log(weatherList);
            let iconURL = `http://openweathermap.org/img/wn/${weatherList[4]}.png`;
            $(".place").html(`${weatherList[0]}`);
            $(".temp").html(`${weatherList[1]}도`);
            $(".display__main").html(`${weatherList[2]}`);
            $(".weatherDesc").html(weatherList[3]);
            $(".Icon").html(`<img style="max-height: 20px; max-width: 20px;" src=${iconURL}></img>`);
        },

        error: function (e) {
            console.log("에러!");
            alert(e.responseText); // error msg는 String이기 때문에 responseText
            //xml을 받을때는 e.responseXml
        }
    });
}
init();