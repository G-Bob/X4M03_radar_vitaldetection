#ifndef DATA_HPP
#define DATA_HPP

#include "Bytes.hpp"
#include "datatypes.h"
#include <vector>
namespace XeThru {


/**
 * @struct DetectionZoneLimits
 *
 * Is an aggrgation of parameters used to represent the detection zone limits.
 *
 * @param start: the start of the detection zone.
 * @param end: the end of the detection zone.
 * @param step: the steps in the detection zone.
 *
 */
struct DetectionZoneLimits
{
    float start;
    float end;
    float step;
};


/**
 * @struct DataFloat
 *
 * Encapulates a vector of float elements, for example baseband data.
 * This package can be retrieved from the module with the use of read_message_data_float in the XEP interface.
 *
 * @param content_id: id that tells what the content is.
 * @param info: this might be some generic information, but  usually it is the frame counter value.
 * @param data: the vector of float elements.
 *
 */
struct DataFloat
{
    uint32_t content_id;
    uint32_t info;
    const std::vector<float> & get_data() {
        return data;
    }

    std::vector<float> get_copy() {
        return data;
    }

    std::vector<float> data;
};


/**
 * @struct FrameArea
 *
 * @param start: the start of the frame area.
 * @param end: the end of the frame area.
 *
 */
struct FrameArea
{
    float start;
    float end;
};


/**
 * @struct DataRecord
 *
 * Encapsulates data and information about one data record on disk. One record is a collection
 * of fields as specified by the Xethru File Formats doc for the given data type.
 *
 * @note Data and information is valid only if \ref is_valid is true.
 *
 * @param data contains bytes as specified by Xethru File Formats doc if is_user_header is false.
 * Otherwise contains custom user header as supplied by the user (see \a RecordingOptions::set_user_header).
 * @param data_type Specifies the data type for the record (see \ref DataType).
 * @param epoch Specifies the date/time the record was written to disk as number of milliseconds since 1970.01.01.
 * @param is_valid Specifies whether the fields in this struct is valid.
 * @param is_user_header Specifies whether the data contains custom user header.
 *
 */
struct DataRecord
{
    DataRecord() : is_valid(false) {}

    /**
     * Const reference accessor to data. In particular useful from Python to avoid unecessary
     * overhead when read-only access to data is needed.
     * @return a const reference to the data.
     */
    const Bytes &get_data() { return data; }

    Bytes data;
    uint32_t data_type;
    int64_t epoch;
    bool is_valid;
    bool is_user_header;
};


/**
 * @class DetectionZone
 *
 * Representation of the detection zone.
 *
 */
struct DetectionZone
{
    /**
     * Start of detection zone in meters from the radar module.
     */
    float start;
    /**
     * End of detection zone in meters from the radar module.
     */
    float end;
};


/**
 * @class RespirationData
 *
 * Represents the respiration status data coming from the module.
 */
class RespirationData
{
public:
    /**
     * A sequential counter from the radar data. Incremented for each captured frame.
     */
    uint32_t frame_counter;

    /**
     * This represent the steady state of the sensor module.
     */
    uint32_t sensor_state;

    /**
     * Respiration rate (respirations per minute / RPM). Valid when SensorState is Breathing.
     */
    uint32_t respiration_rate;

    /**
     * The distance from the sensor to the subject (which the sensor is currently locked on to).
     */
    float distance;
    /**
     * Breathing pattern of closest breathing target: Detected respiratory
     * movement in mm perpendicular to the sensor.
     */
    float movement;

    /**
     * Quality measure of the signal quality, describing the signal-to-noise ratio of the current respiration lock. Value from 0 to 10, 0=low -> 10=high.
     */
    uint32_t signal_quality;
};



/**
 * @class SleepData
 *
 * Represents the sleep status data coming from the module.
 */
class SleepData
{
public:
    /**
     * A sequential counter from the radar data. Incremented for each captured frame.
     */
    uint32_t frame_counter;
    /**
     * This represent the steady state of the sensor module.
     */
    uint32_t sensor_state;
    /**
     * Respiration rate (respirations per minute / RPM). Valid when SensorState is Breathing.
     */
    float respiration_rate;
    /**
     * Is the distance from the sensorto the subject (which the sensor is currently locked on to).
     */
    float distance;
    /**
     * Quality measure of the signal quality, describing the signal-to-noise ratio of the current respiration lock. Value from 0 to 10, 0=low -> 10=high.
     */
    uint32_t signal_quality;
    /**
     * First movement metric which captures the larger movements. It is given as a percentage(0-100). Higher the percentage larger the movement.
     */
    float movement_slow;
    /**
     * Second movement metric which also captures the larger movements. It is represented as a percentage (0-100).
     * Higher the percentage larger the movement.
     * This metric is more responsive than the MovementSlow. It captures the movements faster than the former.
     */
    float movement_fast;
};


/**
 * @class BasebandApData
 *
 * Represents amplitude phase baseband data coming from the module.
 */
class BasebandApData
{
public:
    /**
     * Default constructor
     */
    BasebandApData()
    {}

    /**
     * Constructor
     */
    BasebandApData(
        uint32_t frame_counter,
        uint32_t num_bins,
        float bin_length,
        float sample_frequency,
        float carrier_frequency,
        float range_offset,
        const float * amplitude,
        const float * phase):
        frame_counter(frame_counter),
        num_bins(num_bins),
        bin_length(bin_length),
        sample_frequency(sample_frequency),
        carrier_frequency(carrier_frequency),
        range_offset(range_offset),
        amplitude(amplitude, amplitude + num_bins),
        phase(phase, phase + num_bins)
    {}

    /**
     * Returns a reference to the amplitude vector.
     */
    const std::vector<float> & get_amplitude() { return amplitude; }

    /**
     * Returns a reference to the phase vector.
     */
    const std::vector<float> & get_phase() { return phase; }

    /**
     * A sequential counter from the radar data. Incremented for each captured frame.
     */
    uint32_t frame_counter;
    /**
     * Number of bins in dataset.
     */
    uint32_t num_bins;

    /**
     * Length in meters between each bin.
     */
    float bin_length;

    /**
     * Chip sampling frequency in Hz.
     */
    float sample_frequency;

    /**
     * Chip carrier frequency in Hz.
     */
    float carrier_frequency;

    /**
     * First range bin start in meters.
     */
    float range_offset;

    /**
     * Vector of NumOfBins float values of the signal power.
     */
    std::vector<float> amplitude;

    /**
     * Vector of NumOfBins float values of the signal phase.
     */
    std::vector<float> phase;
};


/**
 * @class BasebandIqData
 *
 * Represents I/Q baseband data coming from the module.
 */
class BasebandIqData
{
public:
    /**
     * Default constructor
     */
    BasebandIqData(){}
    /**
     * Constructor
     */
    BasebandIqData(
        uint32_t frame_counter,
        uint32_t num_bins,
        float bin_length,
        float sample_frequency,
        float carrier_frequency,
        float range_offset,
        const float * i,
        const float * q):
        frame_counter(frame_counter),
        num_bins(num_bins),
        bin_length(bin_length),
        sample_frequency(sample_frequency),
        carrier_frequency(carrier_frequency),
        range_offset(range_offset),
        i_data(i, i + num_bins),
        q_data(q, q + num_bins)
    {}

    /**
     * Returns a reference to the in phase vector.
     */
    const std::vector<float> & get_I() { return i_data; }
    /**
     * Returns a reference to the in quadrature phase vector.
     */
    const std::vector<float> & get_Q() { return q_data; }

    /**
     * A sequential counter from the radar data. Incremented for each captured frame.
     */
    uint32_t frame_counter;
    /**
     * Number of bins in dataset.
     */
    uint32_t num_bins;

    /**
     * Length in meters between each bin.
     */
    float bin_length;

    /**
     * Chip sampling frequency in Hz.
     */
    float sample_frequency;

    /**
     * Chip carrier frequency in Hz.
     */
    float carrier_frequency;

    /**
     * First range bin start in meters.
     */
    float range_offset;

    /**
     * Vector of NumOfBins float values of the inphase signal.
     */
    std::vector<float> i_data;
    /**
     * Vector of NumOfBins float values of the quadrature phase signal.
     */
    std::vector<float> q_data;
};


/**
 * @class PresenceSingleData
 *
 * Encapsulates and aggregates true presenece data coming from the Xethru X4M300 module.
 * @param frame_counter: The frame counter
 * @param presence_state: Presence state output. See xtid.h for values.
 * @param distance: Distance in meters from sensor to presence detected.
 * @param direction: Movement direction of detected object.
 * @param signal_quality: signal quality
 *
 */
class PresenceSingleData
{
public:
    uint32_t frame_counter;
    uint32_t presence_state;
    float distance;
    uint8_t direction;
    uint32_t signal_quality;
};

/**
 * @class PresenceMovingListData
 *
 * Encapsulates and aggregates presence data coming from the Xethru X4M300 module.
 *
 * @param frame_counter: The frame counter
 * @param presence_state: Presence state output. See xtid.h for values.
 * @param movement_slow_items: List of movement metrics split into sections of the detection zone. Longer integration time.
 * @param movement_fast_items: List of movement metrics split into sections of the detection zone. Shorter integration time.
 * @param detection_distance_items: Not implemented.
 * @param radar_cross_section_items: Not implemented.
 * @param detection_velocity_items: Not implemented.
 *
 */
class PresenceMovingListData
{
public:
    uint32_t frame_counter;
    uint32_t presence_state;

    std::vector<float> movement_slow_items;
    std::vector<float> movement_fast_items;
    std::vector<float> detection_distance_items;
    std::vector<float> radar_cross_section_items;
    std::vector<float> detection_velocity_items;

    const std::vector<float> &get_movement_slow_items() { return movement_slow_items; }
    const std::vector<float> &get_movement_fast_items() { return movement_fast_items; }
    const std::vector<float> &get_detection_distance_items() { return detection_distance_items; }
    const std::vector<float> &get_radar_cross_section() { return radar_cross_section_items; }
    const std::vector<float> &get_detection_velocity_items(){ return detection_velocity_items;}
};


struct RespirationMovingListData
{
    uint32_t counter;
    std::vector<float> movement_slow_items;
    std::vector<float> movement_fast_items;
    const std::vector<float> & get_movement_slow_items() { return movement_slow_items; }
    const std::vector<float> & get_movement_fast_items() { return movement_fast_items; }
};


struct RespirationDetectionListData
{
    uint32_t counter;
    uint32_t detection_count;
    std::vector<float> detection_distance_items;
    std::vector<float> detection_radar_cross_section_items;
    std::vector<float> detection_velocity_items;
};


struct Files
{
    std::vector<int32_t> file_type_items;
    std::vector<int32_t> file_identifier_items;
    std::vector<int32_t> get_file_type_items() { return file_type_items; }
    std::vector<int32_t> get_file_identifier_items() { return file_identifier_items; }
};

/**
 * @class PulseDopplerFloatData
 *
 * Represents one half or one range bin of pulse-Doppler in float format.
 */
class PulseDopplerFloatData
{
public:
    PulseDopplerFloatData() {}

    PulseDopplerFloatData(uint32_t frame_counter, uint32_t matrix_counter,
            uint32_t range_idx, uint32_t range_bins, uint32_t frequency_count,
            uint32_t pulsedoppler_instance, float fps, float fps_decimated,
            float frequency_start, float frequency_step, float range,
            const float *data):
        frame_counter(frame_counter), matrix_counter(matrix_counter),
        range_idx(range_idx), range_bins(range_bins),
        frequency_count(frequency_count),
        pulsedoppler_instance(pulsedoppler_instance),
        fps(fps), fps_decimated(fps_decimated),
        frequency_start(frequency_start), frequency_step(frequency_step),
        range(range), data(data, data + frequency_count)
    {}

    /**
     * Returns a reference to the data
     */
    const std::vector<float> & get_data() { return data; }

    /**
     * Frame counter generated from chip data rate
     */
    uint32_t frame_counter;

    /**
     * Incremental matrix counter.
     */
    uint32_t matrix_counter;

    /**
     * Range bin index of current Doppler vector
     */
    uint32_t range_idx;

    /**
     * Number of total range bins in the pulse-Doppler output matrix
     */
    uint32_t range_bins;

    /**
     * Number of points in frequency axis
     */
    uint32_t frequency_count;

    /**
     * Selected pulse-Doppler type from [0..N-1] where N is number of PDs.
     */
    uint32_t pulsedoppler_instance;

    /**
     * Output chip framerate (frames per second)
     */
    float fps;

    /**
     * Input FPS of this pulse-Doppler instance
     */
    float fps_decimated;

    /**
     * Frequency of first value
     */
    float frequency_start;

    /**
     * Difference between each frequency bin
     */
    float frequency_step;

    /**
     * Absolute range of current frequency array
     */
    float range;

    /**
     * Power of pulse-Doppler bins
     */
    std::vector<float> data;
};

/**
 * @class PulseDopplerByteData
 *
 * Represents one half or one range bin of pulse-Doppler in byte format.
 */
class PulseDopplerByteData
{
public:
    PulseDopplerByteData() {}

    PulseDopplerByteData(uint32_t frame_counter, uint32_t matrix_counter,
            uint32_t range_idx, uint32_t range_bins, uint32_t frequency_count,
            uint32_t pulsedoppler_instance, float byte_step_start,
            float byte_step_size, float fps, float fps_decimated,
            float frequency_start, float frequency_step, float range,
            const unsigned char *data):
        frame_counter(frame_counter), matrix_counter(matrix_counter),
        range_idx(range_idx), range_bins(range_bins),
        frequency_count(frequency_count),
        pulsedoppler_instance(pulsedoppler_instance),
        byte_step_start(byte_step_start), byte_step_size(byte_step_size),
        fps(fps), fps_decimated(fps_decimated),
        frequency_start(frequency_start), frequency_step(frequency_step),
        range(range), data(data, data + frequency_count)
    {}
    /**
     * Returns a reference to the data
     */
    const Bytes & get_data() { return data; }

    /**
     * Frame counter generated from chip data rate
     */
    uint32_t frame_counter;

    /**
     * Incremental matrix counter.
     */
    uint32_t matrix_counter;

    /**
     * Range bin index of current Doppler vector
     */
    uint32_t range_idx;

    /**
     * Number of total range bins in the pulse-Doppler output matrix
     */
    uint32_t range_bins;

    /**
     * Number of points in frequency axis
     */
    uint32_t frequency_count;

    /**
     * Selected pulse-Doppler type from [0..N-1] where N is number of PDs.
     */
    uint32_t pulsedoppler_instance;

    /**
     * Start of dB-compression range
     */
    float byte_step_start;

    /**
     * Size of one step in dB
     */
    float byte_step_size;

    /**
     * Output chip framerate (frames per second)
     */
    float fps;

    /**
     * Input FPS of this pulse-Doppler instance
     */
    float fps_decimated;

    /**
     * Frequency of first value
     */
    float frequency_start;

    /**
     * Difference between each frequency bin
     */
    float frequency_step;

    /**
     * Absolute range of current frequency array
     */
    float range;

    /**
     * Power of pulse-Doppler bins
     *
     * \f[
     *      float = 10^{(byte * byte\_step\_size + byte\_step\_start)/10}
     * \f]
     */
    Bytes data;
};


} // namespace XeThru

#endif // DATA_HPP
