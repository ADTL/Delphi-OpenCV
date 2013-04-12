(* /*****************************************************************
  //                       Delphi-OpenCV Demo
  //               Copyright (C) 2013 Project Delphi-OpenCV
  // ****************************************************************
  // Contributor:
  // laentir Valetov
  // email:laex@bk.ru
  // ****************************************************************
  // You may retrieve the latest version of this file at the GitHub,
  // located at git://github.com/Laex/Delphi-OpenCV.git
  // ****************************************************************
  // The contents of this file are used with permission, subject to
  // the Mozilla Public License Version 1.1 (the "License"); you may
  // not use this file except in compliance with the License. You may
  // obtain a copy of the License at
  // http://www.mozilla.org/MPL/MPL-1_1Final.html
  //
  // Software distributed under the License is distributed on an
  // "AS IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or
  // implied. See the License for the specific language governing
  // rights and limitations under the License.
  ******************************************************************* *)
// JCL_DEBUG_EXPERT_GENERATEJDBG OFF
// JCL_DEBUG_EXPERT_INSERTJDBG OFF
// JCL_DEBUG_EXPERT_DELETEMAPFILE OFF
program cv_FloodFill;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils,
uLibName in '..\..\..\include\uLibName.pas',
highgui_c in '..\..\..\include\highgui\highgui_c.pas',
core_c in '..\..\..\include\�ore\core_c.pas',
Core.types_c in '..\..\..\include\�ore\Core.types_c.pas',
imgproc.types_c in '..\..\..\include\imgproc\imgproc.types_c.pas',
imgproc_c in '..\..\..\include\imgproc\imgproc_c.pas',
legacy in '..\..\..\include\legacy\legacy.pas',
calib3d in '..\..\..\include\calib3d\calib3d.pas',
imgproc in '..\..\..\include\imgproc\imgproc.pas',
haar in '..\..\..\include\objdetect\haar.pas',
objdetect in '..\..\..\include\objdetect\objdetect.pas',
tracking in '..\..\..\include\video\tracking.pas',
Core in '..\..\..\include\�ore\core.pas'
  ;

// ������� ������� �������� ������
procedure fill(src: pIplImage; seed: TCvPoint; color: TCvScalar); // = CV_RGB(255, 0, 0)
Var
  comp: TCvConnectedComp;
begin
  cvFloodFill(src, seed, color, cvScalarAll(10), // ����������� ��������
    cvScalarAll(10), // ������������ ��������
    @comp, CV_FLOODFILL_FIXED_RANGE + 8, 0);
  // ������� ������� �������
  WriteLn(Format('[filled area]%.2f', [comp.area]));
end;

// ���������� ������� �� �����
procedure myMouseCallback(event: Integer; x: Integer; y: Integer; flags: Integer; param: Pointer); cdecl;
Var
  img: pIplImage;
begin
  img := pIplImage(param);
  case event of
    CV_EVENT_MOUSEMOVE:
      ;
    CV_EVENT_LBUTTONDOWN:
      begin
        WriteLn(Format('%dx%d', [x, y]));
        // �������� ���� �������-������ ������ cvFloodFill()
        fill(img, CvPoint(x, y), CV_RGB(255, 0, 0));
      end;
    CV_EVENT_LBUTTONUP:
      ;
  end;
end;

Const
  filename = 'Resource\cat2.jpg';

Var
  src: pIplImage = nil;
  dst: pIplImage = nil;
  c: Integer;

begin
  try
    // �������� ��������
    src := cvLoadImage(filename);
    WriteLn(Format('[i] image: %s', [filename]));
    // ������� �����������
    cvNamedWindow('original', 1);
    // ������ ���������� �����
    cvSetMouseCallback('original', myMouseCallback, src);

    while true do
    begin
      // ���������� ��������
      cvShowImage('original', src);
      c := cvWaitKey(33);
      if (c = 27) then // ���� ������ ESC - �������
        break;
    end;
    // ����������� �������
    cvReleaseImage(src);
    cvReleaseImage(dst);
    // ������� ����
    cvDestroyAllWindows;
  except
    on E: Exception do
      WriteLn(E.ClassName, ': ', E.Message);
  end;

end.