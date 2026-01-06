import svgPaths from "./svg-isqvu6sdnq";
import imgImage from "figma:asset/bf5ff9bc72450fc30efc57780f9f1ff658121cbe.png";
import imgImage1 from "figma:asset/c0cc65a4402a729561e9917a6abb6f4fd4e8705c.png";

function Icon() {
  return (
    <div className="h-[24px] overflow-clip relative shrink-0 w-full" data-name="Icon">
      <div className="absolute inset-[14.88%_31.54%_14.88%_28.9%]" data-name="Vector">
        <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 10 17">
          <path d={svgPaths.p53406c0} fill="var(--fill-0, black)" id="Vector" />
        </svg>
      </div>
    </div>
  );
}

function Button() {
  return (
    <div className="absolute content-stretch flex flex-col items-start left-[16px] size-[24px] top-[16px]" data-name="Button">
      <Icon />
    </div>
  );
}

function Paragraph() {
  return (
    <div className="h-[22.398px] relative shrink-0 w-full" data-name="Paragraph">
      <p className="absolute font-['Inter:Semi_Bold',sans-serif] font-semibold leading-[22.4px] left-0 not-italic text-[16px] text-black text-nowrap top-[-1px] whitespace-pre">Hiking in George Bass</p>
    </div>
  );
}

function Paragraph1() {
  return (
    <div className="h-[18px] relative shrink-0 w-full" data-name="Paragraph">
      <p className="absolute font-['Inter:Regular',sans-serif] font-normal leading-[18px] left-0 not-italic text-[12px] text-[rgba(0,0,0,0.5)] text-nowrap top-[0.5px] whitespace-pre">7 People Online</p>
    </div>
  );
}

function Container() {
  return (
    <div className="absolute content-stretch flex flex-col h-[40.398px] items-start left-[92px] top-[7.8px] w-[234px]" data-name="Container">
      <Paragraph />
      <Paragraph1 />
    </div>
  );
}

function Icon1() {
  return (
    <div className="h-[24px] overflow-clip relative shrink-0 w-full" data-name="Icon">
      <div className="absolute inset-[8.33%_8.33%_8.63%_8.8%]" data-name="Vector">
        <div className="absolute inset-[-5.02%_-5.03%]">
          <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 22 22">
            <path d={svgPaths.p3980d00} id="Vector" stroke="var(--stroke-0, black)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" />
          </svg>
        </div>
      </div>
    </div>
  );
}

function Button1() {
  return (
    <div className="absolute content-stretch flex flex-col items-start left-[326px] size-[24px] top-[16px]" data-name="Button">
      <Icon1 />
    </div>
  );
}

function Image() {
  return (
    <div className="absolute left-0 rounded-[1.67772e+07px] size-[32px] top-0" data-name="Image">
      <img alt="" className="absolute inset-0 max-w-none object-50%-50% object-cover pointer-events-none rounded-[1.67772e+07px] size-full" src={imgImage} />
    </div>
  );
}

function Container1() {
  return (
    <div className="absolute bg-[#d4ff00] left-[22px] rounded-[1.67772e+07px] size-[10px] top-[22px]" data-name="Container">
      <div aria-hidden="true" className="absolute border-2 border-solid border-white inset-0 pointer-events-none rounded-[1.67772e+07px]" />
    </div>
  );
}

function Container2() {
  return (
    <div className="absolute left-[52px] size-[32px] top-[12px]" data-name="Container">
      <Image />
      <Container1 />
    </div>
  );
}

function Container3() {
  return (
    <div className="absolute bg-white h-[56px] left-[12px] top-[56px] w-[366px]" data-name="Container">
      <div aria-hidden="true" className="absolute border-[0px_0px_1px] border-black border-solid inset-0 pointer-events-none" />
      <Button />
      <Container />
      <Button1 />
      <Container2 />
    </div>
  );
}

function Container4() {
  return (
    <div className="absolute h-[39.891px] left-[12px] top-[7px] w-[226.5px]" data-name="Container">
      <p className="absolute font-['Inter:Regular',sans-serif] font-normal leading-[19.95px] left-0 not-italic text-[15px] text-white top-0 tracking-[-0.2344px] w-[195px]">{`Everyone ready for the hike? Let's check in! 🏔️`}</p>
    </div>
  );
}

function MessageBubble() {
  return (
    <div className="absolute bg-[#007aff] h-[53.891px] left-[99.5px] rounded-[20px] top-[16px] w-[250.5px]" data-name="MessageBubble">
      <Container4 />
    </div>
  );
}

function CheckInMessage() {
  return (
    <div className="absolute h-[18px] left-[16px] top-[75.89px] w-[334px]" data-name="CheckInMessage">
      <p className="absolute font-['Inter:Regular',sans-serif] font-normal leading-[18px] left-[167.01px] not-italic text-[#666666] text-[12px] text-center text-nowrap top-[0.5px] translate-x-[-50%] whitespace-pre">You checked in</p>
    </div>
  );
}

function Image1() {
  return (
    <div className="absolute left-0 rounded-[1.67772e+07px] size-[24px] top-[7.95px]" data-name="Image">
      <img alt="" className="absolute inset-0 max-w-none object-50%-50% object-cover pointer-events-none rounded-[1.67772e+07px] size-full" src={imgImage1} />
    </div>
  );
}

function Container5() {
  return (
    <div className="absolute h-[19.945px] left-[12px] top-[7px] w-[178.031px]" data-name="Container">
      <p className="absolute font-['Inter:Regular',sans-serif] font-normal leading-[19.95px] left-0 not-italic text-[15px] text-black text-nowrap top-0 tracking-[-0.2344px] whitespace-pre">{`I'm here! Perfect day for it`}</p>
    </div>
  );
}

function Container6() {
  return (
    <div className="absolute bg-[#e9e9eb] h-[33.945px] left-[32px] rounded-[20px] top-0 w-[202.031px]" data-name="Container">
      <Container5 />
    </div>
  );
}

function MessageBubble1() {
  return (
    <div className="absolute h-[33.945px] left-[16px] top-[99.89px] w-[334px]" data-name="MessageBubble">
      <Image1 />
      <Container6 />
    </div>
  );
}

function CheckInMessage1() {
  return (
    <div className="absolute h-[18px] left-[16px] top-[139.84px] w-[334px]" data-name="CheckInMessage">
      <p className="absolute font-['Inter:Regular',sans-serif] font-normal leading-[18px] left-[167.41px] not-italic text-[#666666] text-[12px] text-center text-nowrap top-[0.5px] translate-x-[-50%] whitespace-pre">Tom Checked in</p>
    </div>
  );
}

function CheckInMessage2() {
  return (
    <div className="absolute h-[18px] left-[16px] top-[167.84px] w-[334px]" data-name="CheckInMessage">
      <p className="absolute font-['Inter:Regular',sans-serif] font-normal leading-[18px] left-[167.23px] not-italic text-[#666666] text-[12px] text-center text-nowrap top-[0.5px] translate-x-[-50%] whitespace-pre">Alice Chen Checked in</p>
    </div>
  );
}

function CheckInMessage3() {
  return (
    <div className="absolute h-[18px] left-[16px] top-[195.84px] w-[334px]" data-name="CheckInMessage">
      <p className="absolute font-['Inter:Regular',sans-serif] font-normal leading-[18px] left-[167.47px] not-italic text-[#666666] text-[12px] text-center text-nowrap top-[0.5px] translate-x-[-50%] whitespace-pre">Tom Branson Checked in</p>
    </div>
  );
}

function CheckInMessage4() {
  return (
    <div className="absolute h-[18px] left-[16px] top-[223.84px] w-[334px]" data-name="CheckInMessage">
      <p className="absolute font-['Inter:Regular',sans-serif] font-normal leading-[18px] left-[167.34px] not-italic text-[#666666] text-[12px] text-center text-nowrap top-[0.5px] translate-x-[-50%] whitespace-pre">Eve Smith Checked in</p>
    </div>
  );
}

function CheckInMessage5() {
  return (
    <div className="absolute h-[18px] left-[16px] top-[251.84px] w-[334px]" data-name="CheckInMessage">
      <p className="absolute font-['Inter:Regular',sans-serif] font-normal leading-[18px] left-[167.06px] not-italic text-[#666666] text-[12px] text-center text-nowrap top-[0.5px] translate-x-[-50%] whitespace-pre">Kush Singh Checked in</p>
    </div>
  );
}

function Container7() {
  return (
    <div className="absolute h-[19.945px] left-[12px] top-[7px] w-[159.984px]" data-name="Container">
      <p className="absolute font-['Inter:Regular',sans-serif] font-normal leading-[19.95px] left-0 not-italic text-[15px] text-nowrap text-white top-0 tracking-[-0.2344px] whitespace-pre">Still waiting for Helena?</p>
    </div>
  );
}

function MessageBubble2() {
  return (
    <div className="absolute bg-[#007aff] h-[33.945px] left-[150.02px] rounded-[20px] top-0 w-[183.984px]" data-name="MessageBubble">
      <Container7 />
    </div>
  );
}

function Container8() {
  return (
    <div className="absolute h-[39.891px] left-[12px] top-[7px] w-[226.5px]" data-name="Container">
      <p className="absolute font-['Inter:Regular',sans-serif] font-normal leading-[19.95px] left-0 not-italic text-[15px] text-white top-0 tracking-[-0.2344px] w-[212px]">Should we grab water while we wait?</p>
    </div>
  );
}

function MessageBubble3() {
  return (
    <div className="absolute bg-[#007aff] h-[53.891px] left-[83.5px] rounded-[20px] top-[35.95px] w-[250.5px]" data-name="MessageBubble">
      <Container8 />
    </div>
  );
}

function Container9() {
  return (
    <div className="absolute h-[89.836px] left-[16px] top-[275.84px] w-[334px]" data-name="Container">
      <MessageBubble2 />
      <MessageBubble3 />
    </div>
  );
}

function CheckInMessage6() {
  return (
    <div className="absolute h-[18px] left-[16px] top-[371.67px] w-[334px]" data-name="CheckInMessage">
      <p className="absolute font-['Inter:Regular',sans-serif] font-normal leading-[18px] left-[167.31px] not-italic text-[#666666] text-[12px] text-center text-nowrap top-[0.5px] translate-x-[-50%] whitespace-pre">Helena Hills Checked in</p>
    </div>
  );
}

function Container10() {
  return <div className="absolute bg-gradient-to-b blur-2xl filter from-[#ffd700] left-[224px] opacity-40 rounded-[1.67772e+07px] size-[128px] to-[#ffed4e] top-[-32px]" data-name="Container" />;
}

function Container11() {
  return <div className="absolute bg-gradient-to-b from-[#fff200] left-[256px] opacity-60 rounded-[1.67772e+07px] size-[80px] to-[#ffd700] top-[-16px]" data-name="Container" />;
}

function Container12() {
  return <div className="absolute bg-[rgba(255,255,255,0.8)] left-[292px] opacity-[0.904] rounded-[1.67772e+07px] size-[4px] top-[12px]" data-name="Container" />;
}

function Container13() {
  return <div className="absolute bg-[rgba(255,255,255,0.6)] left-[298px] opacity-[0.544] rounded-[1.67772e+07px] size-[6px] top-[32px]" data-name="Container" />;
}

function Container14() {
  return <div className="absolute bg-[rgba(255,255,255,0.7)] left-[268px] opacity-[0.596] rounded-[1.67772e+07px] size-[4px] top-[24px]" data-name="Container" />;
}

function Container15() {
  return <div className="absolute bg-gradient-to-r from-[rgba(0,0,0,0)] left-[270.32px] opacity-60 size-[35.355px] to-[rgba(0,0,0,0)] top-[-16.68px] via-50% via-[rgba(255,255,255,0.3)]" data-name="Container" />;
}

function Container16() {
  return <div className="absolute bg-gradient-to-r from-[rgba(0,0,0,0)] h-[10.273px] left-[280.23px] opacity-60 to-[rgba(0,0,0,0)] top-[11.86px] via-50% via-[rgba(255,255,255,0.3)] w-[39.542px]" data-name="Container" />;
}

function Container17() {
  return <div className="absolute bg-gradient-to-r from-[rgba(0,0,0,0)] h-[8.61px] left-[256.14px] opacity-60 to-[rgba(0,0,0,0)] top-[4.7px] via-50% via-[rgba(255,255,255,0.3)] w-[31.717px]" data-name="Container" />;
}

function Icon2() {
  return (
    <div className="h-[16px] overflow-clip relative shrink-0 w-full" data-name="Icon">
      <div className="absolute inset-1/4" data-name="Vector">
        <div className="absolute inset-[-8.33%]">
          <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 10 10">
            <path d={svgPaths.p48af40} id="Vector" stroke="var(--stroke-0, white)" strokeLinecap="round" strokeLinejoin="round" strokeOpacity="0.6" strokeWidth="1.33333" />
          </svg>
        </div>
      </div>
      <div className="absolute inset-1/4" data-name="Vector">
        <div className="absolute inset-[-8.33%]">
          <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 10 10">
            <path d={svgPaths.p30908200} id="Vector" stroke="var(--stroke-0, white)" strokeLinecap="round" strokeLinejoin="round" strokeOpacity="0.6" strokeWidth="1.33333" />
          </svg>
        </div>
      </div>
    </div>
  );
}

function Button2() {
  return (
    <div className="absolute content-stretch flex flex-col items-start left-[296px] size-[16px] top-[8px]" data-name="Button">
      <Icon2 />
    </div>
  );
}

function Icon3() {
  return (
    <div className="relative shrink-0 size-[20px]" data-name="Icon">
      <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 20 20">
        <g id="Icon">
          <path d={svgPaths.p3a14cd80} id="Vector" stroke="var(--stroke-0, white)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.66667" />
        </g>
      </svg>
    </div>
  );
}

function Container18() {
  return (
    <div className="absolute bg-[rgba(255,255,255,0.2)] content-stretch flex items-center justify-center left-0 rounded-[1.67772e+07px] size-[40px] top-[4px]" data-name="Container">
      <Icon3 />
    </div>
  );
}

function Heading4() {
  return (
    <div className="h-[21px] relative shrink-0 w-[94.406px]" data-name="Heading 4">
      <div className="bg-clip-padding border-0 border-[transparent] border-solid box-border h-[21px] relative w-[94.406px]">
        <p className="absolute font-['Inter:Semi_Bold',sans-serif] font-semibold leading-[21px] left-0 not-italic text-[14px] text-nowrap text-white top-0 whitespace-pre">Weather Alert</p>
      </div>
    </div>
  );
}

function Text() {
  return (
    <div className="bg-[rgba(255,255,255,0.25)] h-[20.5px] relative rounded-[1.67772e+07px] shrink-0 w-[57.281px]" data-name="Text">
      <div className="bg-clip-padding border-0 border-[transparent] border-solid box-border h-[20.5px] relative w-[57.281px]">
        <p className="absolute font-['Inter:Medium',sans-serif] font-medium leading-[16.5px] left-[8px] not-italic text-[11px] text-nowrap text-white top-[2.5px] whitespace-pre">🔥 35°C</p>
      </div>
    </div>
  );
}

function Container19() {
  return (
    <div className="content-stretch flex gap-[8px] h-[21px] items-center relative shrink-0 w-full" data-name="Container">
      <Heading4 />
      <Text />
    </div>
  );
}

function Paragraph2() {
  return (
    <div className="h-[54.586px] relative shrink-0 w-full" data-name="Paragraph">
      <p className="absolute font-['Inter:Regular',sans-serif] font-normal leading-[18.2px] left-0 not-italic text-[13px] text-[rgba(255,255,255,0.95)] top-0 w-[225px]">High temperature expected during your activity. Stay hydrated and take breaks in the shade! 💧</p>
    </div>
  );
}

function Button3() {
  return (
    <div className="bg-[rgba(255,255,255,0.25)] h-[31.5px] relative rounded-[1.67772e+07px] shrink-0 w-[94.25px]" data-name="Button">
      <div className="bg-clip-padding border-0 border-[transparent] border-solid box-border h-[31.5px] relative w-[94.25px]">
        <p className="absolute font-['Inter:Medium',sans-serif] font-medium leading-[19.5px] left-[12px] not-italic text-[13px] text-nowrap text-white top-[7px] whitespace-pre">Safety Tips</p>
      </div>
    </div>
  );
}

function Button4() {
  return (
    <div className="bg-[rgba(255,255,255,0.1)] h-[31.5px] relative rounded-[1.67772e+07px] shrink-0 w-[57.914px]" data-name="Button">
      <div className="bg-clip-padding border-0 border-[transparent] border-solid box-border h-[31.5px] relative w-[57.914px]">
        <p className="absolute font-['Inter:Medium',sans-serif] font-medium leading-[19.5px] left-[12px] not-italic text-[13px] text-nowrap text-white top-[7px] whitespace-pre">Got it</p>
      </div>
    </div>
  );
}

function Container20() {
  return (
    <div className="content-stretch flex gap-[8px] h-[31.5px] items-start relative shrink-0 w-full" data-name="Container">
      <Button3 />
      <Button4 />
    </div>
  );
}

function Container21() {
  return (
    <div className="absolute content-stretch flex flex-col gap-[8px] h-[127.086px] items-start left-[52px] top-0 w-[236px]" data-name="Container">
      <Container19 />
      <Paragraph2 />
      <Container20 />
    </div>
  );
}

function Container22() {
  return (
    <div className="absolute h-[127.086px] left-[16px] top-[12px] w-[288px]" data-name="Container">
      <Container18 />
      <Container21 />
    </div>
  );
}

function WeatherNotice() {
  return (
    <div className="absolute bg-gradient-to-b from-[#ff6b6b] h-[151.086px] left-[23px] overflow-clip rounded-[18px] shadow-[0px_10px_15px_-3px_rgba(0,0,0,0.1),0px_4px_6px_-4px_rgba(0,0,0,0.1)] to-[#ff8e53] top-[403.67px] w-[320px]" data-name="WeatherNotice">
      <Container10 />
      <Container11 />
      <Container12 />
      <Container13 />
      <Container14 />
      <Container15 />
      <Container16 />
      <Container17 />
      <Button2 />
      <Container22 />
    </div>
  );
}

function Image2() {
  return (
    <div className="absolute left-0 rounded-[1.67772e+07px] size-[24px] top-[27.89px]" data-name="Image">
      <img alt="" className="absolute inset-0 max-w-none object-50%-50% object-cover pointer-events-none rounded-[1.67772e+07px] size-full" src={imgImage1} />
    </div>
  );
}

function Container23() {
  return (
    <div className="absolute h-[39.891px] left-[12px] top-[7px] w-[226.5px]" data-name="Container">
      <p className="absolute font-['Inter:Regular',sans-serif] font-normal leading-[19.95px] left-0 not-italic text-[15px] text-black top-0 tracking-[-0.2344px] w-[214px]">Wow 35°C is intense! Everyone bring sunscreen?</p>
    </div>
  );
}

function Container24() {
  return (
    <div className="absolute bg-[#e9e9eb] h-[53.891px] left-[32px] rounded-[20px] top-0 w-[250.5px]" data-name="Container">
      <Container23 />
    </div>
  );
}

function MessageBubble4() {
  return (
    <div className="absolute h-[53.891px] left-[16px] top-[564.76px] w-[334px]" data-name="MessageBubble">
      <Image2 />
      <Container24 />
    </div>
  );
}

function Container25() {
  return (
    <div className="absolute h-[39.891px] left-[12px] top-[7px] w-[226.5px]" data-name="Container">
      <p className="absolute font-['Inter:Regular',sans-serif] font-normal leading-[19.95px] left-0 not-italic text-[15px] text-white top-0 tracking-[-0.2344px] w-[207px]">Yeah good call on the weather alert</p>
    </div>
  );
}

function MessageBubble5() {
  return (
    <div className="bg-[#007aff] h-[53.891px] relative rounded-[20px] shrink-0 w-full" data-name="MessageBubble">
      <Container25 />
    </div>
  );
}

function Container26() {
  return (
    <div className="absolute h-[39.891px] left-[12px] top-[7px] w-[226.5px]" data-name="Container">
      <p className="absolute font-['Inter:Regular',sans-serif] font-normal leading-[19.95px] left-0 not-italic text-[15px] text-white top-0 tracking-[-0.2344px] w-[217px]">Just bought some water bottles for everyone</p>
    </div>
  );
}

function MessageBubble6() {
  return (
    <div className="bg-[#007aff] h-[53.891px] relative rounded-[20px] shrink-0 w-full" data-name="MessageBubble">
      <Container26 />
    </div>
  );
}

function Container27() {
  return (
    <div className="absolute box-border content-stretch flex flex-col gap-[2px] h-[109.781px] items-start left-[16px] pl-[83.5px] pr-0 py-0 top-[620.65px] w-[334px]" data-name="Container">
      <MessageBubble5 />
      <MessageBubble6 />
    </div>
  );
}

function Icon4() {
  return (
    <div className="relative shrink-0 size-[20px]" data-name="Icon">
      <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 20 20">
        <g clipPath="url(#clip0_62_322)" id="Icon">
          <path d={svgPaths.p34ea8c80} id="Vector" stroke="var(--stroke-0, white)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.66667" />
          <path d="M16.6667 1.66667V5" id="Vector_2" stroke="var(--stroke-0, white)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.66667" />
          <path d="M18.3333 3.33333H15" id="Vector_3" stroke="var(--stroke-0, white)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.66667" />
          <path d={svgPaths.p2661f400} id="Vector_4" stroke="var(--stroke-0, white)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.66667" />
        </g>
        <defs>
          <clipPath id="clip0_62_322">
            <rect fill="white" height="20" width="20" />
          </clipPath>
        </defs>
      </svg>
    </div>
  );
}

function Container28() {
  return (
    <div className="absolute bg-[rgba(255,255,255,0.2)] content-stretch flex items-center justify-center left-0 rounded-[1.67772e+07px] size-[40px] top-[4px]" data-name="Container">
      <Icon4 />
    </div>
  );
}

function Heading5() {
  return (
    <div className="h-[21px] relative shrink-0 w-[146.172px]" data-name="Heading 4">
      <div className="bg-clip-padding border-0 border-[transparent] border-solid box-border h-[21px] relative w-[146.172px]">
        <p className="absolute font-['Inter:Semi_Bold',sans-serif] font-semibold leading-[21px] left-0 not-italic text-[14px] text-nowrap text-white top-0 whitespace-pre">Transaction Detected</p>
      </div>
    </div>
  );
}

function Text1() {
  return (
    <div className="bg-[rgba(255,255,255,0.25)] h-[20.5px] relative rounded-[1.67772e+07px] shrink-0 w-[68.227px]" data-name="Text">
      <div className="bg-clip-padding border-0 border-[transparent] border-solid box-border h-[20.5px] relative w-[68.227px]">
        <p className="absolute font-['Inter:Medium',sans-serif] font-medium leading-[16.5px] left-[8px] not-italic text-[11px] text-nowrap text-white top-[2.5px] whitespace-pre">💳 $45.99</p>
      </div>
    </div>
  );
}

function Container29() {
  return (
    <div className="content-stretch flex gap-[8px] h-[21px] items-center relative shrink-0 w-full" data-name="Container">
      <Heading5 />
      <Text1 />
    </div>
  );
}

function Paragraph3() {
  return (
    <div className="h-[36.391px] relative shrink-0 w-full" data-name="Paragraph">
      <p className="absolute font-['Inter:Regular',sans-serif] font-normal leading-[18.2px] left-0 not-italic text-[13px] text-[rgba(255,255,255,0.95)] top-0 w-[211px]">Would you like to record this as an event expense? 📝</p>
    </div>
  );
}

function Button5() {
  return (
    <div className="bg-white h-[35.5px] relative rounded-[1.67772e+07px] shadow-[0px_4px_6px_-1px_rgba(0,0,0,0.1),0px_2px_4px_-2px_rgba(0,0,0,0.1)] shrink-0 w-[88.273px]" data-name="Button">
      <div className="bg-clip-padding border-0 border-[transparent] border-solid box-border h-[35.5px] relative w-[88.273px]">
        <p className="absolute font-['Inter:Semi_Bold',sans-serif] font-semibold leading-[19.5px] left-[16px] not-italic text-[#00a63e] text-[13px] text-nowrap top-[9px] whitespace-pre">Record It</p>
      </div>
    </div>
  );
}

function Button6() {
  return (
    <div className="bg-[rgba(255,255,255,0.2)] h-[35.5px] relative rounded-[1.67772e+07px] shrink-0 w-[50.859px]" data-name="Button">
      <div className="bg-clip-padding border-0 border-[transparent] border-solid box-border h-[35.5px] relative w-[50.859px]">
        <p className="absolute font-['Inter:Medium',sans-serif] font-medium leading-[19.5px] left-[12px] not-italic text-[13px] text-nowrap text-white top-[9px] whitespace-pre">Skip</p>
      </div>
    </div>
  );
}

function Container30() {
  return (
    <div className="content-stretch flex gap-[8px] h-[35.5px] items-start relative shrink-0 w-full" data-name="Container">
      <Button5 />
      <Button6 />
    </div>
  );
}

function Container31() {
  return (
    <div className="absolute content-stretch flex flex-col gap-[8px] h-[112.891px] items-start left-[52px] top-0 w-[236px]" data-name="Container">
      <Container29 />
      <Paragraph3 />
      <Container30 />
    </div>
  );
}

function Container32() {
  return (
    <div className="absolute h-[112.891px] left-[16px] top-[12px] w-[288px]" data-name="Container">
      <Container28 />
      <Container31 />
    </div>
  );
}

function Icon5() {
  return (
    <div className="h-[16px] overflow-clip relative shrink-0 w-full" data-name="Icon">
      <div className="absolute inset-1/4" data-name="Vector">
        <div className="absolute inset-[-8.33%]">
          <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 10 10">
            <path d={svgPaths.p48af40} id="Vector" stroke="var(--stroke-0, white)" strokeLinecap="round" strokeLinejoin="round" strokeOpacity="0.6" strokeWidth="1.33333" />
          </svg>
        </div>
      </div>
      <div className="absolute inset-1/4" data-name="Vector">
        <div className="absolute inset-[-8.33%]">
          <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 10 10">
            <path d={svgPaths.p30908200} id="Vector" stroke="var(--stroke-0, white)" strokeLinecap="round" strokeLinejoin="round" strokeOpacity="0.6" strokeWidth="1.33333" />
          </svg>
        </div>
      </div>
    </div>
  );
}

function Button7() {
  return (
    <div className="absolute content-stretch flex flex-col items-start left-[296px] size-[16px] top-[8px]" data-name="Button">
      <Icon5 />
    </div>
  );
}

function TransactionNotice() {
  return (
    <div className="absolute bg-gradient-to-b from-[#4ade80] h-[136.891px] left-[23px] rounded-[18px] shadow-[0px_10px_15px_-3px_rgba(0,0,0,0.1),0px_4px_6px_-4px_rgba(0,0,0,0.1)] to-[#22c55e] top-[740.43px] w-[320px]" data-name="TransactionNotice">
      <Container32 />
      <Button7 />
    </div>
  );
}

function Container33() {
  return (
    <div className="relative shrink-0 size-[24px]" data-name="Container">
      <div className="bg-clip-padding border-0 border-[transparent] border-solid box-border size-[24px]" />
    </div>
  );
}

function Container34() {
  return (
    <div className="absolute h-[19.945px] left-[12px] top-[7px] w-[197.828px]" data-name="Container">
      <p className="absolute font-['Inter:Regular',sans-serif] font-normal leading-[19.95px] left-0 not-italic text-[15px] text-black text-nowrap top-0 tracking-[-0.2344px] whitespace-pre">Thanks for getting the water!</p>
    </div>
  );
}

function Container35() {
  return (
    <div className="bg-[#e9e9eb] h-[33.945px] relative rounded-[20px] shrink-0 w-[221.828px]" data-name="Container">
      <div className="bg-clip-padding border-0 border-[transparent] border-solid box-border h-[33.945px] relative w-[221.828px]">
        <Container34 />
      </div>
    </div>
  );
}

function MessageBubble7() {
  return (
    <div className="content-stretch flex gap-[8px] h-[33.945px] items-end relative shrink-0 w-full" data-name="MessageBubble">
      <Container33 />
      <Container35 />
    </div>
  );
}

function Container36() {
  return (
    <div className="relative shrink-0 size-[24px]" data-name="Container">
      <div className="bg-clip-padding border-0 border-[transparent] border-solid box-border size-[24px]" />
    </div>
  );
}

function Container37() {
  return (
    <div className="absolute h-[39.891px] left-[12px] top-[7px] w-[226.5px]" data-name="Container">
      <p className="absolute font-['Inter:Regular',sans-serif] font-normal leading-[19.95px] left-0 not-italic text-[15px] text-black top-0 tracking-[-0.2344px] w-[195px]">We should split the costs for today</p>
    </div>
  );
}

function Container38() {
  return (
    <div className="bg-[#e9e9eb] h-[53.891px] relative rounded-[20px] shrink-0 w-[250.5px]" data-name="Container">
      <div className="bg-clip-padding border-0 border-[transparent] border-solid box-border h-[53.891px] relative w-[250.5px]">
        <Container37 />
      </div>
    </div>
  );
}

function MessageBubble8() {
  return (
    <div className="content-stretch flex gap-[8px] h-[53.891px] items-end relative shrink-0 w-full" data-name="MessageBubble">
      <Container36 />
      <Container38 />
    </div>
  );
}

function Image3() {
  return (
    <div className="absolute left-0 rounded-[1.67772e+07px] size-[24px] top-[27.89px]" data-name="Image">
      <img alt="" className="absolute inset-0 max-w-none object-50%-50% object-cover pointer-events-none rounded-[1.67772e+07px] size-full" src={imgImage1} />
    </div>
  );
}

function Container39() {
  return (
    <div className="absolute h-[39.891px] left-[12px] top-[7px] w-[226.5px]" data-name="Container">
      <p className="absolute font-['Inter:Regular',sans-serif] font-normal leading-[19.95px] left-0 not-italic text-[15px] text-black top-0 tracking-[-0.2344px] w-[154px]">{`I'll create a bill split for everything`}</p>
    </div>
  );
}

function Container40() {
  return (
    <div className="absolute bg-[#e9e9eb] h-[53.891px] left-[32px] rounded-[20px] top-0 w-[250.5px]" data-name="Container">
      <Container39 />
    </div>
  );
}

function MessageBubble9() {
  return (
    <div className="h-[53.891px] relative shrink-0 w-full" data-name="MessageBubble">
      <Image3 />
      <Container40 />
    </div>
  );
}

function Container41() {
  return (
    <div className="absolute content-stretch flex flex-col gap-[2px] h-[145.727px] items-start left-[16px] top-[887.32px] w-[334px]" data-name="Container">
      <MessageBubble7 />
      <MessageBubble8 />
      <MessageBubble9 />
    </div>
  );
}

function Icon6() {
  return (
    <div className="relative shrink-0 size-[20px]" data-name="Icon">
      <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 20 20">
        <g id="Icon">
          <path d={svgPaths.p3e8f800} id="Vector" stroke="var(--stroke-0, white)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.66667" />
          <path d={svgPaths.p11d57a00} id="Vector_2" stroke="var(--stroke-0, white)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.66667" />
        </g>
      </svg>
    </div>
  );
}

function Container42() {
  return (
    <div className="absolute bg-[rgba(255,255,255,0.2)] content-stretch flex items-center justify-center left-0 rounded-[1.67772e+07px] size-[40px] top-[4px]" data-name="Container">
      <Icon6 />
    </div>
  );
}

function Heading6() {
  return (
    <div className="h-[21px] relative shrink-0 w-[113.406px]" data-name="Heading 4">
      <div className="bg-clip-padding border-0 border-[transparent] border-solid box-border h-[21px] relative w-[113.406px]">
        <p className="absolute font-['Inter:Semi_Bold',sans-serif] font-semibold leading-[21px] left-0 not-italic text-[14px] text-nowrap text-white top-0 whitespace-pre">Bill Split Request</p>
      </div>
    </div>
  );
}

function Text2() {
  return (
    <div className="bg-[rgba(255,255,255,0.25)] h-[20.5px] relative rounded-[1.67772e+07px] shrink-0 w-[73.391px]" data-name="Text">
      <div className="bg-clip-padding border-0 border-[transparent] border-solid box-border h-[20.5px] relative w-[73.391px]">
        <p className="absolute font-['Inter:Medium',sans-serif] font-medium leading-[16.5px] left-[8px] not-italic text-[11px] text-nowrap text-white top-[2.5px] whitespace-pre">💸 Pending</p>
      </div>
    </div>
  );
}

function Container43() {
  return (
    <div className="content-stretch flex gap-[8px] h-[21px] items-center relative shrink-0 w-full" data-name="Container">
      <Heading6 />
      <Text2 />
    </div>
  );
}

function Text3() {
  return (
    <div className="h-[19.5px] relative shrink-0 w-[81.602px]" data-name="Text">
      <div className="bg-clip-padding border-0 border-[transparent] border-solid box-border h-[19.5px] relative w-[81.602px]">
        <p className="absolute font-['Inter:Regular',sans-serif] font-normal leading-[19.5px] left-0 not-italic text-[13px] text-[rgba(255,255,255,0.8)] text-nowrap top-px whitespace-pre">Total Amount</p>
      </div>
    </div>
  );
}

function Text4() {
  return (
    <div className="h-[24px] relative shrink-0 w-[38.461px]" data-name="Text">
      <div className="bg-clip-padding border-0 border-[transparent] border-solid box-border h-[24px] relative w-[38.461px]">
        <p className="absolute font-['Inter:Semi_Bold',sans-serif] font-semibold leading-[24px] left-0 not-italic text-[16px] text-nowrap text-white top-[-1px] whitespace-pre">$231</p>
      </div>
    </div>
  );
}

function Container44() {
  return (
    <div className="content-stretch flex h-[24px] items-center justify-between relative shrink-0 w-full" data-name="Container">
      <Text3 />
      <Text4 />
    </div>
  );
}

function Text5() {
  return (
    <div className="h-[19.5px] relative shrink-0 w-[66.945px]" data-name="Text">
      <div className="bg-clip-padding border-0 border-[transparent] border-solid box-border h-[19.5px] relative w-[66.945px]">
        <p className="absolute font-['Inter:Regular',sans-serif] font-normal leading-[19.5px] left-0 not-italic text-[13px] text-[rgba(255,255,255,0.8)] text-nowrap top-px whitespace-pre">Your Share</p>
      </div>
    </div>
  );
}

function Text6() {
  return (
    <div className="h-[27px] relative shrink-0 w-[35.148px]" data-name="Text">
      <div className="bg-clip-padding border-0 border-[transparent] border-solid box-border h-[27px] relative w-[35.148px]">
        <p className="absolute font-['Inter:Semi_Bold',sans-serif] font-semibold leading-[27px] left-0 not-italic text-[#d4ff00] text-[18px] text-nowrap top-[0.5px] whitespace-pre">$33</p>
      </div>
    </div>
  );
}

function Container45() {
  return (
    <div className="content-stretch flex h-[27px] items-center justify-between relative shrink-0 w-full" data-name="Container">
      <Text5 />
      <Text6 />
    </div>
  );
}

function Icon7() {
  return (
    <div className="relative shrink-0 size-[14px]" data-name="Icon">
      <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 14 14">
        <g id="Icon">
          <path d={svgPaths.p317fdd80} id="Vector" stroke="var(--stroke-0, white)" strokeLinecap="round" strokeLinejoin="round" strokeOpacity="0.7" strokeWidth="1.16667" />
          <path d={svgPaths.pc62e8b0} id="Vector_2" stroke="var(--stroke-0, white)" strokeLinecap="round" strokeLinejoin="round" strokeOpacity="0.7" strokeWidth="1.16667" />
          <path d={svgPaths.pe97dd00} id="Vector_3" stroke="var(--stroke-0, white)" strokeLinecap="round" strokeLinejoin="round" strokeOpacity="0.7" strokeWidth="1.16667" />
          <path d={svgPaths.p31c78b80} id="Vector_4" stroke="var(--stroke-0, white)" strokeLinecap="round" strokeLinejoin="round" strokeOpacity="0.7" strokeWidth="1.16667" />
        </g>
      </svg>
    </div>
  );
}

function Text7() {
  return (
    <div className="h-[18px] relative shrink-0 w-[142.641px]" data-name="Text">
      <div className="bg-clip-padding border-0 border-[transparent] border-solid box-border h-[18px] relative w-[142.641px]">
        <p className="absolute font-['Inter:Regular',sans-serif] font-normal leading-[18px] left-0 not-italic text-[12px] text-[rgba(255,255,255,0.7)] text-nowrap top-[0.5px] whitespace-pre">{`2 people haven't paid yet`}</p>
      </div>
    </div>
  );
}

function Container46() {
  return (
    <div className="box-border content-stretch flex gap-[8px] h-[23px] items-center pb-0 pt-px px-0 relative shrink-0 w-full" data-name="Container">
      <div aria-hidden="true" className="absolute border-[1px_0px_0px] border-[rgba(255,255,255,0.2)] border-solid inset-0 pointer-events-none" />
      <Icon7 />
      <Text7 />
    </div>
  );
}

function Container47() {
  return (
    <div className="bg-[rgba(255,255,255,0.1)] h-[114px] relative rounded-[12px] shrink-0 w-full" data-name="Container">
      <div className="size-full">
        <div className="box-border content-stretch flex flex-col gap-[8px] h-[114px] items-start pb-0 pt-[12px] px-[12px] relative w-full">
          <Container44 />
          <Container45 />
          <Container46 />
        </div>
      </div>
    </div>
  );
}

function Icon8() {
  return (
    <div className="absolute left-[101.43px] size-[14px] top-[10.75px]" data-name="Icon">
      <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 14 14">
        <g id="Icon">
          <path d="M2.91667 7H11.0833" id="Vector" stroke="var(--stroke-0, #9810FA)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.16667" />
          <path d={svgPaths.pf23dd00} id="Vector_2" stroke="var(--stroke-0, #9810FA)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.16667" />
        </g>
      </svg>
    </div>
  );
}

function Button8() {
  return (
    <div className="basis-0 bg-white grow h-[35.5px] min-h-px min-w-px relative rounded-[1.67772e+07px] shadow-[0px_4px_6px_-1px_rgba(0,0,0,0.1),0px_2px_4px_-2px_rgba(0,0,0,0.1)] shrink-0" data-name="Button">
      <div className="bg-clip-padding border-0 border-[transparent] border-solid box-border h-[35.5px] relative w-full">
        <p className="absolute font-['Inter:Semi_Bold',sans-serif] font-semibold leading-[19.5px] left-[45.88px] not-italic text-[#9810fa] text-[13px] text-nowrap top-[9px] whitespace-pre">Pay $33</p>
        <Icon8 />
      </div>
    </div>
  );
}

function Button9() {
  return (
    <div className="bg-[rgba(255,255,255,0.2)] h-[35.5px] relative rounded-[1.67772e+07px] shrink-0 w-[66.695px]" data-name="Button">
      <div className="bg-clip-padding border-0 border-[transparent] border-solid box-border h-[35.5px] relative w-[66.695px]">
        <p className="absolute font-['Inter:Medium',sans-serif] font-medium leading-[19.5px] left-[12px] not-italic text-[13px] text-nowrap text-white top-[9px] whitespace-pre">Details</p>
      </div>
    </div>
  );
}

function Container48() {
  return (
    <div className="content-stretch flex gap-[8px] h-[35.5px] items-start relative shrink-0 w-full" data-name="Container">
      <Button8 />
      <Button9 />
    </div>
  );
}

function Container49() {
  return (
    <div className="absolute content-stretch flex flex-col gap-[8px] h-[190.5px] items-start left-[52px] top-0 w-[236px]" data-name="Container">
      <Container43 />
      <Container47 />
      <Container48 />
    </div>
  );
}

function Container50() {
  return (
    <div className="h-[190.5px] relative shrink-0 w-full" data-name="Container">
      <Container42 />
      <Container49 />
    </div>
  );
}

function BillSplitRequest() {
  return (
    <div className="absolute bg-gradient-to-b box-border content-stretch flex flex-col from-[#a855f7] h-[214.5px] items-start left-[23px] pb-0 pt-[12px] px-[16px] rounded-[18px] shadow-[0px_10px_15px_-3px_rgba(0,0,0,0.1),0px_4px_6px_-4px_rgba(0,0,0,0.1)] to-[#ec4899] top-[1043.05px] w-[320px]" data-name="BillSplitRequest">
      <Container50 />
    </div>
  );
}

function Container51() {
  return (
    <div className="absolute h-[19.945px] left-[12px] top-[7px] w-[206.211px]" data-name="Container">
      <p className="absolute font-['Inter:Regular',sans-serif] font-normal leading-[19.95px] left-0 not-italic text-[15px] text-nowrap text-white top-0 tracking-[-0.2344px] whitespace-pre">Perfect! Just paid my share 💸</p>
    </div>
  );
}

function MessageBubble10() {
  return (
    <div className="absolute bg-[#007aff] h-[33.945px] left-[119.79px] rounded-[20px] top-[1267.55px] w-[230.211px]" data-name="MessageBubble">
      <Container51 />
    </div>
  );
}

function Container52() {
  return (
    <div className="absolute h-[638px] left-[12px] overflow-clip top-[112px] w-[366px]" data-name="Container">
      <MessageBubble />
      <CheckInMessage />
      <MessageBubble1 />
      <CheckInMessage1 />
      <CheckInMessage2 />
      <CheckInMessage3 />
      <CheckInMessage4 />
      <CheckInMessage5 />
      <Container9 />
      <CheckInMessage6 />
      <WeatherNotice />
      <MessageBubble4 />
      <Container27 />
      <TransactionNotice />
      <Container41 />
      <BillSplitRequest />
      <MessageBubble10 />
    </div>
  );
}

function Group() {
  return (
    <div className="absolute contents inset-[4.19%_0.51%_9.7%_63.93%]" data-name="Group">
      <div className="absolute inset-[4.19%_4.73%_9.7%_63.93%]" data-name="Vector">
        <div className="absolute inset-[-4.97%_-2.32%]">
          <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 22 11">
            <path d={svgPaths.p2439aa80} id="Vector" opacity="0.35" stroke="var(--stroke-0, black)" strokeWidth="0.969439" />
          </svg>
        </div>
      </div>
      <div className="absolute inset-[30.58%_0.51%_36.09%_97.51%]" data-name="Vector">
        <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 2 4">
          <path d={svgPaths.p75cc4f0} fill="var(--fill-0, black)" id="Vector" opacity="0.4" />
        </svg>
      </div>
      <div className="absolute inset-[16.69%_6.96%_22.2%_66.17%]" data-name="Vector">
        <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 18 7">
          <path d={svgPaths.p1006b480} fill="var(--fill-0, black)" id="Vector" />
        </svg>
      </div>
    </div>
  );
}

function Group1() {
  return (
    <div className="absolute bottom-[8.31%] contents left-0 right-[0.51%] top-0" data-name="Group">
      <Group />
      <div className="absolute bottom-[8.62%] left-[32.88%] right-[44.33%] top-0" data-name="Vector">
        <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 16 11">
          <path d={svgPaths.pb411a00} fill="var(--fill-0, black)" id="Vector" />
        </svg>
      </div>
      <div className="absolute bottom-[8.31%] left-0 right-[74.63%] top-[2.8%]" data-name="Vector">
        <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 17 11">
          <path d={svgPaths.p379ce780} fill="var(--fill-0, black)" id="Vector" />
        </svg>
      </div>
    </div>
  );
}

function Icon9() {
  return (
    <div className="h-[11.336px] overflow-clip relative shrink-0 w-full" data-name="Icon">
      <Group1 />
    </div>
  );
}

function Container53() {
  return (
    <div className="absolute content-stretch flex flex-col h-[11.336px] items-start left-[284.68px] top-[17.33px] w-[66.656px]" data-name="Container">
      <Icon9 />
    </div>
  );
}

function Group2() {
  return (
    <div className="absolute contents inset-[24.61%_24.3%_22.59%_23.06%]" data-name="Group">
      <div className="absolute inset-[24.61%_61.84%_22.59%_23.06%]" data-name="Vector">
        <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 9 12">
          <path d={svgPaths.p1f203dc0} fill="var(--fill-0, black)" id="Vector" />
        </svg>
      </div>
      <div className="absolute inset-[39.78%_53.95%_23.08%_41.71%]" data-name="Vector">
        <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 3 8">
          <path d={svgPaths.p36ca6500} fill="var(--fill-0, black)" id="Vector" />
        </svg>
      </div>
      <div className="absolute inset-[25.86%_35.26%_23.81%_49.19%]" data-name="Vector">
        <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 9 11">
          <path d={svgPaths.p18ddee00} fill="var(--fill-0, black)" id="Vector" />
        </svg>
      </div>
      <div className="absolute inset-[25.86%_24.3%_23.81%_67.1%]" data-name="Vector">
        <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 5 11">
          <path d={svgPaths.p7f1ea00} fill="var(--fill-0, black)" id="Vector" />
        </svg>
      </div>
    </div>
  );
}

function Group3() {
  return (
    <div className="absolute contents inset-[24.61%_24.3%_22.59%_23.06%]" data-name="Group">
      <Group2 />
    </div>
  );
}

function Icon10() {
  return (
    <div className="h-[21px] overflow-clip relative shrink-0 w-full" data-name="Icon">
      <Group3 />
    </div>
  );
}

function Container54() {
  return (
    <div className="absolute content-stretch flex flex-col h-[21px] items-start left-[21px] top-[12px] w-[54px]" data-name="Container">
      <Icon10 />
    </div>
  );
}

function Container55() {
  return (
    <div className="absolute bg-white h-[44px] left-[12px] overflow-clip top-[12px] w-[366px]" data-name="Container">
      <Container53 />
      <Container54 />
    </div>
  );
}

function Container56() {
  return <div className="absolute bg-black h-[5px] left-[116px] opacity-30 rounded-[100px] top-[69px] w-[134px]" data-name="Container" />;
}

function Icon11() {
  return (
    <div className="relative shrink-0 size-[16px]" data-name="Icon">
      <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 16 16">
        <g id="Icon">
          <path d="M3.33333 8H12.6667" id="Vector" stroke="var(--stroke-0, white)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.33333" />
          <path d="M8 3.33333V12.6667" id="Vector_2" stroke="var(--stroke-0, white)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.33333" />
        </g>
      </svg>
    </div>
  );
}

function Button10() {
  return (
    <div className="bg-gradient-to-b from-[#a855f7] relative rounded-[1.67772e+07px] shadow-[0px_4px_6px_-1px_rgba(0,0,0,0.1),0px_2px_4px_-2px_rgba(0,0,0,0.1)] shrink-0 size-[28px] to-[#ec4899]" data-name="Button">
      <div className="bg-clip-padding border-0 border-[transparent] border-solid box-border content-stretch flex items-center justify-center relative size-[28px]">
        <Icon11 />
      </div>
    </div>
  );
}

function TextInput() {
  return (
    <div className="basis-0 grow h-[21px] min-h-px min-w-px relative shrink-0" data-name="Text Input">
      <div className="bg-clip-padding border-0 border-[transparent] border-solid box-border content-stretch flex h-[21px] items-center overflow-clip relative rounded-[inherit] w-full">
        <p className="font-['Inter:Regular',sans-serif] font-normal leading-[normal] not-italic relative shrink-0 text-[#666666] text-[14px] text-nowrap tracking-[-0.1504px] whitespace-pre">Message</p>
      </div>
    </div>
  );
}

function Icon12() {
  return (
    <div className="h-[24px] overflow-clip relative shrink-0 w-full" data-name="Icon">
      <div className="absolute inset-[4.17%_37.5%_37.5%_37.5%]" data-name="Vector">
        <div className="absolute inset-[-7.14%_-16.67%]">
          <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 8 16">
            <path d={svgPaths.p2ba10400} id="Vector" stroke="var(--stroke-0, #666666)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" />
          </svg>
        </div>
      </div>
      <div className="absolute inset-[41.67%_20.83%_20.83%_20.83%]" data-name="Vector">
        <div className="absolute inset-[-11.11%_-7.14%]">
          <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 16 11">
            <path d={svgPaths.p8d49ac0} id="Vector" stroke="var(--stroke-0, #666666)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" />
          </svg>
        </div>
      </div>
      <div className="absolute bottom-[4.17%] left-1/2 right-1/2 top-[79.17%]" data-name="Vector">
        <div className="absolute inset-[-25%_-1px]">
          <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 2 6">
            <path d="M1 1V5" id="Vector" stroke="var(--stroke-0, #666666)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" />
          </svg>
        </div>
      </div>
      <div className="absolute inset-[95.83%_33.33%_4.17%_33.33%]" data-name="Vector">
        <div className="absolute inset-[-1px_-12.5%]">
          <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 10 2">
            <path d="M1 1H9" id="Vector" stroke="var(--stroke-0, #666666)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" />
          </svg>
        </div>
      </div>
    </div>
  );
}

function Container57() {
  return (
    <div className="relative shrink-0 size-[24px]" data-name="Container">
      <div className="bg-clip-padding border-0 border-[transparent] border-solid box-border content-stretch flex flex-col items-start relative size-[24px]">
        <Icon12 />
      </div>
    </div>
  );
}

function Container58() {
  return (
    <div className="absolute bg-neutral-100 box-border content-stretch flex gap-[12px] h-[46px] items-center left-[16px] px-[13px] py-px rounded-[1.67772e+07px] top-[17px] w-[334px]" data-name="Container">
      <div aria-hidden="true" className="absolute border border-[#e0e0e0] border-solid inset-0 pointer-events-none rounded-[1.67772e+07px]" />
      <Button10 />
      <TextInput />
      <Container57 />
    </div>
  );
}

function Container59() {
  return (
    <div className="absolute bg-white h-[82px] left-[12px] top-[750px] w-[366px]" data-name="Container">
      <div aria-hidden="true" className="absolute border-[#e0e0e0] border-[1px_0px_0px] border-solid inset-0 pointer-events-none" />
      <Container56 />
      <Container58 />
    </div>
  );
}

function Container60() {
  return (
    <div className="absolute bg-white h-[844px] left-[591.5px] rounded-[48px] top-[239px] w-[390px]" data-name="Container">
      <div className="h-[844px] overflow-clip relative rounded-[inherit] w-[390px]">
        <Container3 />
        <Container52 />
        <Container55 />
        <Container59 />
      </div>
      <div aria-hidden="true" className="absolute border-[12px] border-black border-solid inset-0 pointer-events-none rounded-[48px] shadow-[0px_25px_50px_-12px_rgba(0,0,0,0.25)]" />
    </div>
  );
}

function App() {
  return (
    <div className="bg-gray-100 h-[1322px] relative shrink-0 w-full" data-name="App">
      <Container60 />
    </div>
  );
}

export default function GroupMessagingUi() {
  return (
    <div className="bg-white content-stretch flex flex-col items-start relative size-full" data-name="Group Messaging UI">
      <App />
    </div>
  );
}