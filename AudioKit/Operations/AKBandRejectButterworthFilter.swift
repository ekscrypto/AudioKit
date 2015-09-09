//
//  AKBandRejectButterworthFilter.swift
//  AudioKit
//
//  Autogenerated by scripts by Aurelius Prochazka on 9/8/15.
//  Copyright (c) 2015 Aurelius Prochazka. All rights reserved.
//

import Foundation

/** A band-reject Butterworth filter.

These filters are Butterworth second-order IIR filters. They offer an almost flat passband and very good precision and stopband attenuation.
*/
@objc class AKBandRejectButterworthFilter : AKParameter {

    // MARK: - Properties

    private var butbr = UnsafeMutablePointer<sp_butbr>.alloc(1)
    private var input = AKParameter()


    /** Center frequency. (in Hertz) [Default Value: 3000] */
    var centerFrequency: AKParameter = akp(3000) {
        didSet { centerFrequency.bind(&butbr.memory.freq) }
    }

    /** Bandwidth. (in Hertz) [Default Value: 2000] */
    var bandwidth: AKParameter = akp(2000) {
        didSet { bandwidth.bind(&butbr.memory.bw) }
    }


    // MARK: - Initializers

    /** Instantiates the filter with default values */
    init(input source: AKParameter)

    {
        super.init()
        input = source
        setup()
        bindAll()
    }

    /**
    Instantiates the filter with all values

    :param: input Input audio signal. 
    :param: centerFrequency Center frequency. (in Hertz) [Default Value: 3000]
    :param: bandwidth Bandwidth. (in Hertz) [Default Value: 2000]
    */
    convenience init(
        input           source: AKParameter,
        centerFrequency freq:   AKParameter,
        bandwidth       bw:     AKParameter)
    {
        self.init(input: source)

        centerFrequency = freq
        bandwidth       = bw

        bindAll()
    }

    // MARK: - Internals

    /** Bind every property to the internal filter */
    internal func bindAll() {
        centerFrequency.bind(&butbr.memory.freq)
        bandwidth      .bind(&butbr.memory.bw)
    }

    /** Internal set up function */
    internal func setup() {
        sp_butbr_create(&butbr)
        sp_butbr_init(AKManager.sharedManager.data, butbr)
    }

    /** Computation of the next value */
    override func compute() -> Float {
        sp_butbr_compute(AKManager.sharedManager.data, butbr, &(input.value), &value);
        pointer.memory = value
        return value
    }

    /** Release of memory */
    override func teardown() {
        sp_butbr_destroy(&butbr)
    }
}