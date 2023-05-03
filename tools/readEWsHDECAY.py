def read(brfolder, phase=None):
    """
    Reads the N2HDECAY output in the brfolder and returns a dictionary containing all of the N2HDECAY results. If the phase is not specified it is deduced automatically based on the files present in brfolder. This only works if the folder only contains output files for one phase.
    """
    import os.path
    import glob

    RxSMbroken_channels = {
        "br.rb11": [
            "m_H1",
            "b_H1_bb",
            "b_H1_tautau",
            "b_H1_mumu",
            "b_H1_ss",
            "b_H1_cc",
            "b_H1_tt",
        ],
        "br.rb12": [
            "m_H1",
            "b_H1_gg",
            "b_H1_gamgam",
            "b_H1_Zgam",
            "b_H1_WW",
            "b_H1_ZZ",
            "w_H1",
        ],
        "br.rb13": [
            "m_H1",
            "b_H1_H2H2",
        ],
        "br.rb21": [
            "m_H2",
            "b_H2_bb",
            "b_H2_tautau",
            "b_H2_mumu",
            "b_H2_ss",
            "b_H2_cc",
            "b_H2_tt",
        ],
        "br.rb22": [
            "m_H2",
            "b_H2_gg",
            "b_H2_gamgam",
            "b_H2_Zgam",
            "b_H2_WW",
            "b_H2_ZZ",
            "w_H2",
        ],
        "br.rb23": [
            "m_H2",
            "b_H2_H1H1",
        ]
    }

    RxSMdark_channels = {
        "br.rd11": [
            "m_H1",
            "b_H1_bb",
            "b_H1_tautau",
            "b_H1_mumu",
            "b_H1_ss",
            "b_H1_cc",
            "b_H1_tt",
        ],
        "br.rd12": [
            "m_H1",
            "b_H1_gg",
            "b_H1_gamgam",
            "b_H1_Zgam",
            "b_H1_WW",
            "b_H1_ZZ",
            "w_H1",
        ],
        "br.rd13": [
            "m_H1",
            "b_H1_HDHD",
        ],
    }

    CxSMbroken_channels = {
        "br.cb11": [
            "m_H1",
            "b_H1_bb",
            "b_H1_tautau",
            "b_H1_mumu",
            "b_H1_ss",
            "b_H1_cc",
            "b_H1_tt",
        ],
        "br.cb12": [
            "m_H1",
            "b_H1_gg",
            "b_H1_gamgam",
            "b_H1_Zgam",
            "b_H1_WW",
            "b_H1_ZZ",
            "w_H1",
        ],
        "br.cb13": [
            "m_H1",
            "b_H1_H2H2",
            "b_H1_H2H3",
            "b_H1_H3H3",
        ],
        "br.cb21": [
            "m_H2",
            "b_H2_bb",
            "b_H2_tautau",
            "b_H2_mumu",
            "b_H2_ss",
            "b_H2_cc",
            "b_H2_tt",
        ],
        "br.cb22": [
            "m_H2",
            "b_H2_gg",
            "b_H2_gamgam",
            "b_H2_Zgam",
            "b_H2_WW",
            "b_H2_ZZ",
            "w_H2",
        ],
        "br.cb23": [
            "m_H2",
            "b_H2_H1H1",
            "b_H2_H1H3",
            "b_H2_H3H3",
        ],
        "br.cb31": [
            "m_H3",
            "b_H3_bb",
            "b_H3_tautau",
            "b_H3_mumu",
            "b_H3_ss",
            "b_H3_cc",
            "b_H3_tt",
        ],
        "br.cb32": [
            "m_H3",
            "b_H3_gg",
            "b_H3_gamgam",
            "b_H3_Zgam",
            "b_H3_WW",
            "b_H3_ZZ",
            "w_H3",
        ],
        "br.cb33": [
            "m_H3",
            "b_H3_H1H1",
            "b_H3_H1H2",
            "b_H3_H2H2",
        ]
    }


    CxSMdark_channels = {
        "br.cd11": [
            "m_H1",
            "b_H1_bb",
            "b_H1_tautau",
            "b_H1_mumu",
            "b_H1_ss",
            "b_H1_cc",
            "b_H1_tt",
        ],
        "br.cd12": [
            "m_H1",
            "b_H1_gg",
            "b_H1_gamgam",
            "b_H1_Zgam",
            "b_H1_WW",
            "b_H1_ZZ",
            "w_H1",
        ],
        "br.cd13": [
            "m_H1",
            "b_H1_H2H2",
            "b_H1_H2HD",
            "b_H1_HDHD",
        ],
        "br.cd21": [
            "m_H2",
            "b_H2_bb",
            "b_H2_tautau",
            "b_H2_mumu",
            "b_H2_ss",
            "b_H2_cc",
            "b_H2_tt",
        ],
        "br.cd22": [
            "m_H2",
            "b_H2_gg",
            "b_H2_gamgam",
            "b_H2_Zgam",
            "b_H2_WW",
            "b_H2_ZZ",
            "w_H2",
        ],
        "br.cd23": [
            "m_H2",
            "b_H2_H1H1",
            "b_H2_H1HD",
            "b_H2_HDHD",
        ]
    }

    CxSMdarkNLO_channels = {
        "br.cd11": [
            "m_H1",
            "b_H1_bb",
            "b_H1_tautau",
            "b_H1_mumu",
            "b_H1_ss",
            "b_H1_cc",
            "b_H1_tt",
        ],
        "br.cd12": [
            "m_H1",
            "b_H1_gg",
            "b_H1_gamgam",
            "b_H1_Zgam",
            "b_H1_WW",
            "b_H1_ZZ",
            "w_H1",
        ],
        "br.cd13": [
            "m_H1",
            "b_H1_H2H2",
            "b_H1_H2HD",
            "b_H1_HDHD",
        ],
        "br.cd21": [
            "m_H2",
            "b_H2_bb",
            "b_H2_tautau",
            "b_H2_mumu",
            "b_H2_ss",
            "b_H2_cc",
            "b_H2_tt",
        ],
        "br.cd22": [
            "m_H2",
            "b_H2_gg",
            "b_H2_gamgam",
            "b_H2_Zgam",
            "b_H2_WW",
            "b_H2_ZZ",
            "w_H2",
        ],
        "br.cd23": [
            "m_H2",
            "b_H2_H1H1",
            "b_H2_H1HD",
            "b_H2_HDHD",
        ]
    }





    channels = [{}, RxSMbroken_channels,RxSMdark_channels,CxSMbroken_channels,CxSMdark_channels,CxSMdarkNLO_channels]

    def deduce_phase(files):
        filenames = sorted([os.path.basename(x) for x in files])
        filenames.remove("br.input")
        for i in (1,2,3,4,5):
            if filenames == sorted(list(channels[i].keys())):
                return i
        return False

    files = []
    if not phase:
        files = glob.glob(os.path.join(brfolder, "br.*"))
        phase = deduce_phase(files)
        if not phase:
            raise RuntimeError(
                "Could not deduce phase, make sure that the folder only contains the output of a single run."
            )
    else:
        try:
            files = [os.path.join(brfolder, x) for x in channels[phase].keys()]
        except IndexError:
            raise RuntimeError(
                "Unrecognized phase given, accepted values are 1 (broken phase), 2 (DSP), 3 (IDP) or None (deduce phase from files)."
            )

    brdict = {}
    for infile in files:
        print("infile: ",infile)
        if ("br.input" in infile):
            print("continue")
            continue
        with open(infile, "r") as f:
            lines = f.readlines()
        brdict.update(
            dict(
                zip(
                    channels[phase][os.path.basename(infile)],
                    [float(x) for x in lines[-1].split()],
                )
            )
        )
    return brdict

