object Form2: TForm2
  Left = -217
  Top = 2
  AlphaBlend = True
  AlphaBlendValue = 250
  AutoSize = True
  BorderIcons = []
  BorderStyle = bsSingle
  BorderWidth = 2
  Caption = 'MSB'
  ClientHeight = 772
  ClientWidth = 781
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Visible = True
  PixelsPerInch = 96
  TextHeight = 13
  object Panel3: TPanel
    Left = 401
    Top = 0
    Width = 380
    Height = 772
    Margins.Left = 0
    Margins.Top = 0
    Margins.Right = 0
    Margins.Bottom = 0
    Align = alLeft
    BevelEdges = []
    BevelOuter = bvNone
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 0
    object PB2: TPaintBox
      Left = 23
      Top = 200
      Width = 354
      Height = 354
    end
    object Button5: TButton
      Left = 0
      Top = 0
      Width = 17
      Height = 772
      Align = alLeft
      Caption = '>>'
      TabOrder = 0
      OnClick = Button5Click
    end
    object TLBox: TListBox
      Left = 23
      Top = 1
      Width = 50
      Height = 193
      Style = lbOwnerDrawFixed
      Color = clMoneyGreen
      DragMode = dmAutomatic
      ItemHeight = 16
      TabOrder = 1
      OnClick = TLBoxClick
      OnDragDrop = LBDragDrop
      OnDragOver = ListBox2DragOver
      OnDrawItem = LBDrawItem
      OnKeyUp = TLBoxKeyUp
    end
    object Button6: TButton
      Left = 79
      Top = 1
      Width = 75
      Height = 25
      Caption = 'Load Treck'
      TabOrder = 2
      OnClick = Button6Click
    end
    object RichEdit1: TRichEdit
      Left = 79
      Top = 57
      Width = 298
      Height = 137
      ScrollBars = ssVertical
      TabOrder = 3
    end
    object Edit1: TEdit
      Left = 79
      Top = 32
      Width = 298
      Height = 19
      TabOrder = 4
    end
    object Button4: TButton
      Left = 300
      Top = 1
      Width = 75
      Height = 25
      Caption = 'Save'
      TabOrder = 5
      OnClick = Button4Click
    end
    object TBR1: TTrackBar
      Left = 23
      Top = 560
      Width = 355
      Height = 17
      Hint = #1052#1072#1089#1096#1090#1072#1073
      LineSize = 5
      Max = 50000
      Min = 1
      ParentShowHint = False
      PageSize = 5
      Frequency = 5
      Position = 1500
      SelEnd = 25
      ShowHint = True
      TabOrder = 6
      ThumbLength = 12
      TickMarks = tmBoth
      TickStyle = tsNone
    end
  end
  object Panel4: TPanel
    Left = 0
    Top = 0
    Width = 401
    Height = 772
    Align = alLeft
    BevelOuter = bvNone
    Caption = 'Panel4'
    TabOrder = 1
    object PageControl1: TPageControl
      Left = 0
      Top = 17
      Width = 400
      Height = 755
      ActivePage = TabSheet1
      Align = alLeft
      ParentShowHint = False
      ShowHint = False
      TabOrder = 0
      TabWidth = 30
      object TabSheet1: TTabSheet
        Hint = #1056#1072#1076#1072#1088
        Caption = 'R'
        ParentShowHint = False
        ShowHint = True
        object Gauge3: TGauge
          Left = 5
          Top = 16
          Width = 164
          Height = 6
          BackColor = clBtnFace
          ForeColor = clBlue
          Progress = 0
          ShowText = False
        end
        object TBR: TTrackBar
          Left = 3
          Top = 392
          Width = 382
          Height = 17
          Hint = #1052#1072#1089#1096#1090#1072#1073
          LineSize = 5
          Max = 25000
          Min = 1500
          ParentShowHint = False
          PageSize = 5
          Frequency = 5
          Position = 1500
          SelEnd = 25
          ShowHint = True
          TabOrder = 0
          ThumbLength = 12
          TickMarks = tmBoth
          TickStyle = tsNone
        end
        object Panel1: TPanel
          Left = 5
          Top = 6
          Width = 380
          Height = 380
          BevelOuter = bvLowered
          BorderStyle = bsSingle
          Color = clBlack
          Ctl3D = False
          ParentCtl3D = False
          TabOrder = 1
          object Shp1: TShape
            Left = 190
            Top = 190
            Width = 7
            Height = 7
            Brush.Color = clLime
            ParentShowHint = False
            Shape = stCircle
            ShowHint = False
          end
          object PB: TPaintBox
            Left = 1
            Top = 1
            Width = 376
            Height = 376
            Align = alClient
            ExplicitLeft = 144
            ExplicitTop = 152
            ExplicitWidth = 105
            ExplicitHeight = 105
          end
        end
        object Button2: TButton
          Left = 300
          Top = 320
          Width = 75
          Height = 25
          Caption = 'Load Map'
          TabOrder = 2
          OnClick = Button2Click
        end
        object CIDRGroup: TRadioGroup
          Left = 3
          Top = 415
          Width = 379
          Height = 42
          BiDiMode = bdLeftToRight
          Caption = #1055#1086#1076#1082#1083#1102#1095#1077#1085#1080#1103
          Columns = 3
          ParentBiDiMode = False
          TabOrder = 3
        end
        object Button1: TButton
          Left = 300
          Top = 351
          Width = 75
          Height = 25
          Caption = 'Save Treck'
          TabOrder = 4
          OnClick = Button1Click
        end
        object SpinEdit1: TSpinEdit
          Left = 15
          Top = 355
          Width = 64
          Height = 22
          MaxValue = 0
          MinValue = 0
          TabOrder = 5
          Value = 0
          OnChange = SpinEdit1Change
        end
        object RSE: TSpinEdit
          Left = 80
          Top = 355
          Width = 64
          Height = 22
          MaxValue = 0
          MinValue = 0
          TabOrder = 6
          Value = 0
          OnChange = RSEChange
        end
        object TrMemo: TMemo
          Left = 3
          Top = 463
          Width = 382
          Height = 261
          TabOrder = 7
        end
        object CposEdit: TEdit
          Left = 149
          Top = 355
          Width = 145
          Height = 21
          TabOrder = 8
        end
      end
      object TabSheet4: TTabSheet
        Hint = #1048#1085#1092#1086#1088#1084#1072#1094#1080#1103' '#1087#1086' '#1095#1072#1088#1091
        Caption = 'I'
        ImageIndex = 3
        ParentShowHint = False
        ShowHint = True
        object PageControl2: TPageControl
          Left = 0
          Top = 0
          Width = 392
          Height = 727
          Align = alClient
          Style = tsFlatButtons
          TabOrder = 0
        end
      end
      object TabSheet3: TTabSheet
        Hint = #1051#1086#1075
        Caption = 'L'
        ImageIndex = 2
        ParentShowHint = False
        ShowHint = True
        object Memo1: TMemo
          Left = 0
          Top = 0
          Width = 392
          Height = 727
          Align = alClient
          ScrollBars = ssVertical
          TabOrder = 0
        end
      end
      object TabSheet5: TTabSheet
        Caption = 'A'
        ImageIndex = 4
        ParentShowHint = False
        ShowHint = True
        object Button_3: TButton
          Left = 3
          Top = 3
          Width = 75
          Height = 25
          Caption = 'Button_3'
          TabOrder = 0
          OnClick = Button_3Click
        end
        object Button3: TButton
          Left = 84
          Top = 3
          Width = 75
          Height = 25
          Caption = 'Button3'
          TabOrder = 1
          OnClick = Button3Click
        end
      end
    end
    object Panel2: TPanel
      Left = 0
      Top = 0
      Width = 401
      Height = 17
      Align = alTop
      ParentBackground = False
      TabOrder = 1
      object CheckBox1: TCheckBox
        Left = 379
        Top = 1
        Width = 15
        Height = 15
        Hint = 'Stay On Top'
        Checked = True
        Color = clBtnFace
        ParentColor = False
        ParentShowHint = False
        ShowHint = True
        State = cbChecked
        TabOrder = 0
        OnClick = CheckBox1Click
      end
      object TrackBar3: TTrackBar
        Left = 12
        Top = 0
        Width = 349
        Height = 17
        Hint = #1055#1088#1086#1079#1088#1072#1095#1085#1086#1089#1090#1100
        Max = 250
        Min = 30
        ParentShowHint = False
        Position = 250
        ShowHint = True
        TabOrder = 1
        ThumbLength = 10
        TickMarks = tmBoth
        TickStyle = tsNone
        OnChange = TrackBar3Change
      end
    end
  end
  object ImageList1: TImageList
    Left = 48
    Top = 80
    Bitmap = {
      494C010107000900040010001000FFFFFFFFFF00FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000002000000001002000000000000020
      000000000000000000000000000000000000080C10FF0D0E15FF101018FF1010
      18FF906450FF7D4D3AFF887C80FF887C80FF887670FFA0A4A0FFB8B8B0FF9884
      78FF181820FF181820FF151E32FF202C48FF0A111AFF0D121DFF101522FF1016
      25FF000010FF000010FF000028FF000028FF000010FF000010FF000408FF100E
      28FF18223AFF203050FF28365DFF283962FF080808FF080808FF000400FF0004
      00FF080408FF080408FF0A0C15FF101420FF151E35FF182440FF202D4AFF2030
      50FF223255FF25355AFF283860FF283A62FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000D0E15FF101018FF101018FFA850
      30FF6A3625FF582010FF501408FF501408FF581C10FF581C10FF581C08FF9884
      78FF5D5150FF181820FF151E32FF202C48FF0D121DFF101420FF101625FF1018
      28FF181835FF181835FF000028FF000028FF0D0C32FF0D0C32FF100E28FF0004
      08FF18223AFF203050FF283962FF283C68FF080808FF585654FFC8C8C0FFC8C8
      C0FF080408FF080408FF0A0C15FF0D101AFF12192AFF182440FF202D4AFF2030
      50FF25355AFF283860FF283A62FF283D65FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000101018FF10111AFF381C18FF7852
      38FF8D4028FF682818FF7A2D1AFF7A2D1AFF903418FF808888FF702C1AFF4814
      08FFF8E8D8FF402020FF152035FF203050FF101420FF101625FF12192AFF1219
      2AFF8590D8FFC8D0F8FFA8B0E0FF727CD5FFD0DCE0FF9099CAFF2838A8FF2838
      A8FF080800FF181E38FF2A3860FF2D3C68FF080408FF989898FFE8E4E0FFD0CE
      CAFF8A8A88FF000808FF080810FF080810FF121628FF181C30FF1D2945FF2030
      50FF28365DFF283962FF283C68FF2A3E6AFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000010111AFF101420FF381C18FF7852
      38FFB25838FFB25838FF7A2D1AFF7A2D1AFF903418FF903418FF98442DFF702C
      1AFFF8E8D8FF402020FF152035FF203050FF101522FF101828FF12192AFF1219
      2AFF4250B8FF001098FF0814C0FF0814C0FF1014A0FF1014A0FF2838A8FF2838
      A8FF080800FF181E38FF2D3C68FF304070FF080408FF989898FFE8E4E0FFE8E4
      E0FFD0CCC8FF8A8A88FF080810FF080810FF0D1120FF121628FF1A223AFF2030
      50FF283962FF283C68FF2A3E6AFF2D416DFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000101420FF101522FF201820FFB098
      90FFDA7E60FFDA7E60FFE2B8A5FFB84020FFA83C28FFA83C28FF883C28FF883C
      28FFF8E0D0FF301C20FF202C48FF283458FF101828FF151A2DFF181C30FF181C
      30FF000400FF4844D0FF2A39C5FF101CC0FF101070FF101070FF000400FF0004
      00FF1D2642FF223155FF2A3E6DFF2D4172FF101420FF000400FF989690FFE0DC
      D0FFDDDCD8FFCACCC8FF959695FF100C10FF101118FF101118FF151A2DFF2028
      48FF283860FF283860FF2A416DFF2D4272FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000101522FF101828FF201820FFF8D8
      C8FFF0D4C0FFE5A990FFF8F4E8FFB84020FFBD816DFFBD816DFFBD9482FF883C
      28FFB59E95FF301C20FF283458FF303C68FF151A2DFF181C30FF182135FF1821
      35FF181945FF000400FF3848C8FF1D2AC2FF101070FF101070FF10142AFF2024
      55FF223155FF283C68FF2D4172FF304478FF181C30FF101420FF080C10FF9896
      90FFF0ECE8FFDDDCD8FFD8DCD8FF525152FF000000FF101118FF101420FF1A21
      3AFF223155FF283860FF2A416DFF304478FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000101828FF121A2AFF182030FF9D70
      5AFF9D624AFF9D624AFF824235FF824235FF602418FFD0CCC0FFB8A9A0FF9072
      68FF202840FF202840FF2A3960FF304470FF181C30FF181E32FF1A223AFF1D25
      3DFF1A253DFF000000FF3844D0FF1826CAFF000048FF32367AFF0D1422FF2834
      58FF2A3C65FF2D406AFF304575FF30467AFF181C30FF181E32FF080C12FF0000
      00FFA2A19DFFE8E8E0FFE0E4E0FFE0E4E0FF404548FF000810FF0D111DFF1018
      28FF1A2842FF203050FF304070FF304070FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000121A2AFF151D2DFF182030FF1820
      30FFCA9D7DFFCA9D7DFF824235FF824235FF602418FFD0CCC0FFB8A9A0FFB8A9
      A0FF202840FF202840FF2D3E68FF304470FF181E32FF182135FF1D253DFF2028
      40FF1A253DFF000000FF2835CDFF0818C8FF000048FF000048FF0D1422FF2834
      58FF2D406AFF304470FF304575FF30467AFF181E32FF182135FF182438FF080C
      12FF181418FFA2A19DFFE0E4E0FFA5A9A5FF808280FF404548FF0D111DFF0D11
      1DFF152035FF1A2842FF2A3962FF304070FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000181C30FF182135FF182438FF1D26
      3DFF484C58FF707070FF958E88FF605C58FF606060FFE0E0D8FFB8B8B0FF1820
      30FF253255FF2A3962FF304475FF30487AFF182038FF18223AFF1A2642FF1D29
      45FF1D2945FF080400FFD0D0D0FFD0D0D0FF807A7AFF504848FF121525FF2838
      60FF2D4472FF2D4472FF32467AFF35497DFF182038FF18223AFF1A2642FF1D29
      45FF202C48FF101118FF989995FF989995FF858585FF505458FF080C10FF080C
      10FF0D1420FF101C30FF223150FF283C60FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000182135FF182438FF1D263DFF2028
      40FF202840FF989488FFB0A8A0FF605C58FF8A8A88FFE0E0D8FF686C70FF1820
      30FF2A3962FF304070FF304475FF30487AFF18223AFF18253DFF1D2945FF202C
      48FF1D2945FF080400FF7A7A75FFD0D0D0FF504848FF504848FF121525FF2838
      60FF2D4472FF304878FF35497DFF384C80FF18223AFF18253DFF1D2945FF202C
      48FF202C48FF202C48FF505652FFE0DCD8FF858585FF858585FF323940FF080C
      10FF0D1420FF0D1420FF1D2640FF283C60FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000001A223AFF1D253DFF202840FF202A
      45FF202D48FF203050FFC0CCD0FF708C90FF627D82FFC8D0C8FF101828FF2830
      3DFF25365DFF304478FF32497DFF354A82FF182440FF1D2945FF202C48FF202E
      4DFF202D4DFF000000FFA8ACA8FFA8ACA8FF5D6060FF5D6060FF0D1628FF283C
      68FF324475FF35487AFF384C80FF384D82FF182440FF1D2945FF202C48FF202E
      4DFF203050FF25355AFF000400FF303C60FFE0E4E0FF202830FF182030FF4A52
      5DFF283040FF0D1520FF151E35FF202C50FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000001D253DFF202840FF202A45FF202D
      4AFF203050FF202838FF98ACB0FF708C90FF627D82FF95A6A5FF101828FF2830
      3DFF25365DFF304478FF32497DFF354A82FF1A2642FF202C48FF202E4DFF2030
      50FF202D4DFF000000FFA8ACA8FF585C5DFF182020FF182020FF0D1628FF283C
      68FF35487AFF384C80FF384D82FF384E85FF1A2642FF202C48FF202E4DFF2030
      50FF223255FF25355AFF303C60FF000400FF60666AFF202830FFB0B8B8FF1820
      30FF0D1520FF0D1520FF151E35FF202C50FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000202840FF202A45FF222E4DFF2531
      52FF203458FF185D78FF5A7A82FF104048FF0D4C5AFF0D4C5AFF182440FF1824
      40FF283A65FF384880FF384D82FF384E85FF202A45FF202D4AFF203050FF2532
      55FF253250FF253250FF101820FF101820FF080C10FF080C10FF101828FF3040
      68FF32487DFF354C82FF384E85FF38518AFF202A45FF202D4AFF203050FF2532
      55FF28365DFF283962FF2A3A65FF2D3D6AFF000408FF707888FF20314DFF283E
      62FF202E4DFF181C28FF1A2135FF253252FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000202A45FF202D4AFF253152FF2834
      58FF203458FF108698FFF0F0F8FF104048FF187C90FF0D4C5AFF182440FF1824
      40FF283A65FF384880FF384E85FF385088FF202D4AFF203050FF253255FF2834
      58FF253250FF253250FF505D68FF90A2B0FF404448FF080C10FF202C48FF3040
      68FF32487DFF354C82FF38518AFF38518AFF202D4AFF203050FF253255FF2834
      58FF28365DFF283962FF2D3D6AFF304070FF000408FF707888FF20314DFF304C
      78FF284172FF305498FF101018FF304470FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000222E4DFF222E4DFF283458FF2836
      5AFF283C60FF28697DFF457078FF103C48FF081820FF103845FF304468FF3044
      68FF2D4472FF384C88FF385088FF38518AFF222E4DFF253152FF283458FF2836
      5DFF25385AFF203050FF425D70FF6088A0FF353D4AFF000000FF202C4DFF3044
      78FF384D82FF385088FF38518AFF38528DFF222E4DFF253152FF283458FF2836
      5DFF283860FF2A3A65FF30416DFF30416DFF304575FF30467AFF182030FF324D
      80FF385898FF1D2842FF385088FF385088FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000253152FF283458FF28365AFF2839
      5DFF283C60FF28C4B8FFB0D8D8FF457078FF18586AFF207890FF304468FF3044
      68FF32487DFF384C88FF38518AFF38528DFF253152FF283458FF28365DFF2838
      60FF283C60FF223455FF425D70FF253240FF1A1E25FF000000FF283862FF3044
      78FF384E85FF385088FF38518AFF38528DFF253152FF283458FF28365DFF2838
      60FF2A3A65FF2D3D6AFF30416DFF304272FF30467AFF30467AFF324D80FF2536
      58FF101018FF385898FF385088FF385088FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000080C10FF080C10FF180800FF1808
      00FF000808FF000808FF0A0C15FF101420FF151E35FF182440FF202D4AFF2030
      50FF223255FF25355AFF283860FF283A62FF080C10FF0D0E15FF101018FF1010
      18FF586C88FF586C88FF989CA8FF989CA8FFB8C0C0FFB8C0C0FFD0D4D8FF909A
      AAFF181C28FF181C28FF1A253DFF202C48FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000080C10FF725145FF743C24FF743C
      24FF2A1810FF000808FF0A0C15FF0D101AFF12192AFF182440FF202D4AFF2030
      50FF25355AFF283860FF283A62FF283D65FF0D0E15FF101018FF101018FF5070
      B0FF283E62FF283E62FF102850FF102850FF102C58FF102C58FF102850FF909A
      AAFF4D5465FF181C28FF151E32FF202C48FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000080C10FF886E65FFD2A995FFA85C
      40FF7D3922FF581808FF080810FF080810FF121628FF181C30FF1D2945FF2030
      50FF28365DFF283962FF283C68FF2A3E6AFF101018FF10111AFF181C28FF5256
      6DFF2D487AFF102C58FF183460FF183460FF184088FF90A0C0FF152D52FF0010
      28FFE0ECF8FF000420FF151C2DFF202C48FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000080C10FF886E65FFE8D0C0FFBD82
      6AFFA25A3DFF7D3922FF080810FF080810FF0D1120FF121628FF1A223AFF2030
      50FF283962FF283C68FF2A3E6AFF2D416DFF10111AFF101420FF181C28FF5256
      6DFF4A649DFF4A649DFF1D4282FF1D4282FF184088FF184088FF4068A8FF152D
      52FFE0ECF8FF000420FF151C2DFF202C48FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000121522FF080808FFA88070FFF8BC
      A0FFBD765AFFA04420FF824830FF080000FF151115FF151115FF151A2DFF2028
      48FF283860FF283860FF2A416DFF2D4272FF101420FF101522FF181828FF929D
      ADFF6D7CBAFFA2ACD5FFA5B9DDFF1044A8FF1850A0FF1850A0FF4D6588FF1834
      60FFD0E0F8FF081020FF101828FF202A48FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000181C30FF121522FF080810FFA880
      70FFF8DCD0FFBD765AFFC06C48FF824830FF000008FF151115FF101420FF1A21
      3AFF223155FF283860FF2A416DFF304478FF101522FF101828FF181828FFD0E0
      F0FFD8DCF0FFA2ACD5FFF0F4F8FF1044A8FF6D92C0FF98B4D0FFB8C8D8FF1834
      60FF8D9AB0FF081020FF182138FF283458FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000181C30FF181E32FF0D1422FF0004
      08FF9A7D70FFE8BCA8FFC88458FFC88458FF201818FF201818FF0D111AFF1018
      28FF1A2842FF203050FF304070FF304070FF101828FF121A2AFF182030FF6878
      A0FF5A5C75FF5A5C75FF5D6985FF284478FF506580FFD0D0D0FFC8D0D8FF8D96
      A5FF101828FF101828FF1D2C48FF283C68FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000181E32FF182135FF1A243DFF0D14
      22FF4D3E38FFE8BCA8FFE8CEADFFD8A982FF957862FF201818FF0D111AFF0D11
      1AFF152035FF1A2842FF2A3962FF304070FF121A2AFF151D2DFF182030FF1820
      30FFD0CCE0FF9594AAFF284478FF284478FF103058FFD0D0D0FF8D96A5FFC8D0
      D8FF101828FF101828FF223458FF283C68FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000182038FF18223AFF1A2642FF1D29
      45FF203050FF203050FFA09A95FFA09A95FFA8AAA8FF485058FF080C10FF080C
      10FF0D1420FF101C30FF223150FF283C60FF181C30FF182135FF182438FF1D26
      3DFF4A4D5AFF4A4D5AFF95918DFF605C58FF686868FFF0F0E8FF8D8C8DFF181C
      28FF101828FF202A48FF2A3A62FF304878FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000018223AFF18253DFF1D2945FF202C
      48FF203050FF203050FF585552FFE8E0D8FFA8AAA8FFA8AAA8FF383940FF080C
      10FF0D1420FF0D1420FF1D2640FF283C60FF182135FF182438FF1D263DFF2028
      40FF202840FFA09890FFB0ACA8FF605C58FF959592FFC2C2BDFF52545AFF181C
      28FF182138FF283458FF2D416DFF304878FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000182440FF1D2945FF202C48FF202E
      4DFF203050FF25355AFF080408FF303C60FFE0E0E0FF202430FF182030FF4A52
      5DFF202635FF101522FF151E35FF202C50FF1A223AFF1D253DFF202840FF202A
      45FF20304DFF20304DFFC8D0D0FF729295FF657E80FFD0D4D0FF101828FF1018
      28FF203155FF283A62FF32467AFF35497DFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000001A2642FF202C48FF202E4DFF2030
      50FF223255FF25355AFF303C60FF080408FF60626AFF202430FFB0B8B8FF1820
      30FF101522FF101522FF151E35FF202C50FF1D253DFF202840FF202A45FF202D
      4AFF20304DFF202838FF9DB1B2FF729295FF657E80FF9AA9A8FF101828FF1018
      28FF203155FF304470FF35497DFF384C80FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000202A45FF202D4AFF203050FF2532
      55FF28365DFF283962FF2A3A65FF2D3D6AFF000408FF687488FF20314DFF283E
      62FF202E4DFF181C28FF1A2135FF253252FF202840FF202A45FF222E4DFF2531
      52FF283458FF1D607AFF5A7982FF103C48FF0D4A5DFF0D4A5DFF101C30FF101C
      30FF253158FF304478FF384A82FF384D85FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000202D4AFF203050FF253255FF2834
      58FF28365DFF283962FF2D3D6AFF304070FF000408FF687488FF20314DFF304C
      78FF284172FF305498FF101018FF304470FF202A45FF202D4AFF253152FF2834
      58FF283458FF128C9DFFF0F4F8FF103C48FF188098FF0D4A5DFF101C30FF101C
      30FF253158FF304478FF384D85FF385088FF00FF000000FF000000FF000000FF
      000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF
      000000FF000000FF000000FF0000000000000000FF000000FF000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000FF000000FF0000000000222E4DFF253152FF283458FF2836
      5DFF283860FF2A3A65FF30416DFF30416DFF304575FF30467AFF102030FF304C
      80FF3860A8FF181C28FF304575FF385088FF222E4DFF222E4DFF283458FF2836
      5AFF283C60FF286980FF456E75FF103840FF081820FF081820FF182840FF1828
      40FF25355AFF304880FF38518AFF38518AFF00FF000000FF000000FF000000FF
      000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF
      000000FF000000FF000000FF0000000000000000FF000000FF000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000FF000000FF0000000000253152FF283458FF28365DFF2838
      60FF2A3A65FF2D3D6AFF30416DFF304272FF30467AFF30467AFF304C80FF253D
      65FF181C28FF2D497DFF385088FF385088FF253152FF283458FF28365AFF2839
      5DFF283C60FF28C4C0FFB0DCE0FF456E75FF185A70FF207C98FF182840FF1828
      40FF2A3E6DFF304880FF38518AFF385490FF424D3E000000000000003E000000
      2800000040000000200000000100010000000000000100000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FFFFFFFF00000000FFFFFFFF00000000
      FFFFFFFF00000000FFFFFFFF00000000FFFFFFFF00000000FFFFFFFF00000000
      FFFFFFFF00000000FFFFFFFF00000000FFFFFFFF00000000FFFFFFFF00000000
      FFFFFFFF00000000FFFFFFFF00000000FFFFFFFF00000000FFFFFFFF00000000
      00010001000000000001000100000000}
  end
  object Timer1: TTimer
    Interval = 100
    OnTimer = Timer1Timer
    Left = 16
    Top = 80
  end
  object PM: TPopupMenu
    OnPopup = PMPopup
    Left = 80
    Top = 80
    object ADD1: TMenuItem
      Caption = 'ADD to'
      object AutoBuff1: TMenuItem
        Tag = 24
        Caption = 'AutoBaf'
        OnClick = FBUF1Click
      end
      object FBuf2: TMenuItem
        Tag = 21
        Caption = 'FBuf'
      end
      object MBuf2: TMenuItem
        Tag = 22
        Caption = 'MBuf'
      end
      object AllBuf2: TMenuItem
        Tag = 23
        Caption = 'AllBuf'
      end
      object WarList1: TMenuItem
        Tag = 34
        Caption = 'WarList'
      end
      object FrendList1: TMenuItem
        Tag = 35
        Caption = 'FrendList'
      end
    end
    object Remove1: TMenuItem
      Caption = 'Remove'
      object FBUF1: TMenuItem
        Tag = 25
        Caption = 'FBuf'
        OnClick = FBUF1Click
      end
      object MBuf1: TMenuItem
        Tag = 26
        Caption = 'MBuf'
      end
      object AllBuF1: TMenuItem
        Tag = 27
        Caption = 'AutoBaf'
        OnClick = FBUF1Click
      end
    end
    object Ignor1: TMenuItem
      Tag = 28
      Caption = 'Ignor'
      OnClick = FBUF1Click
    end
    object MAS1: TMenuItem
      Tag = 29
      Caption = 'MAS'
      OnClick = FBUF1Click
    end
    object MCS1: TMenuItem
      Tag = 38
      Caption = 'MCS'
      OnClick = FBUF1Click
    end
    object MDS1: TMenuItem
      Tag = 30
      Caption = 'MDS'
      OnClick = FBUF1Click
    end
    object MBS1: TMenuItem
      Tag = 31
      Caption = 'MBS'
      OnClick = FBUF1Click
    end
    object SetLiader1: TMenuItem
      Tag = 33
      Caption = 'Set Lider'
      OnClick = FBUF1Click
    end
    object Save1: TMenuItem
      Tag = 50
      Caption = 'Save'
      OnClick = FBUF1Click
    end
  end
  object OPD: TOpenDialog
    Filter = 'Treck File|*.trk'
    Left = 112
    Top = 80
  end
  object ActionManager1: TActionManager
    Left = 144
    Top = 80
    StyleName = 'XP Style'
  end
  object ApplicationEvents1: TApplicationEvents
    Left = 176
    Top = 80
  end
  object ActionList1: TActionList
    Left = 208
    Top = 80
    object MyClick: TAction
      Caption = 'MyClick'
    end
    object MyDblClick: TAction
      Caption = 'MyDblClick'
    end
  end
end
