#pragma OPENCL EXTENSION cl_amd_printf : enable

//beginning of the looooooong gpu_random_generator kernel 
//we use the open sourced threefry's GPU implementation
typedef uint uint32_t;

struct r123array4x32 {	uint32_t v[4]; };

enum r123_enum_threefry32x4 
{
	R_32x4_0_0 = 10, R_32x4_0_1 = 26,
	R_32x4_1_0 = 11, R_32x4_1_1 = 21,
	R_32x4_2_0 = 13, R_32x4_2_1 = 27,
	R_32x4_3_0 = 23, R_32x4_3_1 =  5,
	R_32x4_4_0 =  6, R_32x4_4_1 = 20,
	R_32x4_5_0 = 17, R_32x4_5_1 = 11,
	R_32x4_6_0 = 25, R_32x4_6_1 = 10,
	R_32x4_7_0 = 18, R_32x4_7_1 = 20
};

inline uint32_t	RotL_32(uint32_t x, unsigned int N)__attribute__((always_inline));
inline uint32_t RotL_32(uint32_t x, unsigned int N)
{
	return (x << (N & 31)) | (x >> ((32 - N) & 31));
}

typedef struct r123array4x32 threefry4x32_ctr_t;
typedef struct r123array4x32 threefry4x32_key_t;
typedef struct r123array4x32 threefry4x32_ukey_t;

inline threefry4x32_ctr_t threefry4x32_R(unsigned int Nrounds, threefry4x32_ctr_t in, threefry4x32_key_t k)__attribute__((always_inline));
inline threefry4x32_ctr_t threefry4x32_R(unsigned int Nrounds, threefry4x32_ctr_t in, threefry4x32_key_t k)
{
	threefry4x32_ctr_t	X;
	uint32_t			ks[4 + 1];
	int					i;
	ks[4] = 0x1BD11BDA;
	/*
	for (i = 0; i < 4; i++)
	{
		ks[i] = k.v[i];
		X.v[i] = in.v[i];
		ks[4] ^= k.v[i];
	}*/ 
	{
		ks[0] = k.v[0];
		X.v[0] = in.v[0];
		ks[4] ^= k.v[0];

		ks[1] = k.v[1];
		X.v[1] = in.v[1];
		ks[4] ^= k.v[1];

		ks[2] = k.v[2];
		X.v[2] = in.v[2];
		ks[4] ^= k.v[2];

		ks[3] = k.v[3];
		X.v[3] = in.v[3];
		ks[4] ^= k.v[3];
	}
	X.v[0] += ks[0];
	X.v[1] += ks[1];
	X.v[2] += ks[2];
	X.v[3] += ks[3];
	if (Nrounds > 0) 
	{
		X.v[0] += X.v[1];
		X.v[1] = RotL_32(X.v[1], R_32x4_0_0);
		X.v[1] ^= X.v[0];
		X.v[2] += X.v[3];
		X.v[3] = RotL_32(X.v[3], R_32x4_0_1);
		X.v[3] ^= X.v[2];
	} if (Nrounds > 1) {
		X.v[0] += X.v[3];
		X.v[3] = RotL_32(X.v[3], R_32x4_1_0);
		X.v[3] ^= X.v[0];
		X.v[2] += X.v[1];
		X.v[1] = RotL_32(X.v[1], R_32x4_1_1);
		X.v[1] ^= X.v[2];
	} if (Nrounds > 2) {
		X.v[0] += X.v[1];
		X.v[1] = RotL_32(X.v[1], R_32x4_2_0);
		X.v[1] ^= X.v[0];
		X.v[2] += X.v[3];
		X.v[3] = RotL_32(X.v[3], R_32x4_2_1);
		X.v[3] ^= X.v[2];
	} if (Nrounds > 3) {
		X.v[0] += X.v[3];
		X.v[3] = RotL_32(X.v[3], R_32x4_3_0);
		X.v[3] ^= X.v[0];
		X.v[2] += X.v[1];
		X.v[1] = RotL_32(X.v[1], R_32x4_3_1);
		X.v[1] ^= X.v[2];
	} if (Nrounds > 3) {
		X.v[0] += ks[1];
		X.v[1] += ks[2];
		X.v[2] += ks[3];
		X.v[3] += ks[4];
		X.v[4 - 1] += 1;
	} if (Nrounds > 4) {
		X.v[0] += X.v[1];
		X.v[1] = RotL_32(X.v[1], R_32x4_4_0);
		X.v[1] ^= X.v[0];
		X.v[2] += X.v[3];
		X.v[3] = RotL_32(X.v[3], R_32x4_4_1);
		X.v[3] ^= X.v[2];
	} if (Nrounds > 5) {
		X.v[0] += X.v[3];
		X.v[3] = RotL_32(X.v[3], R_32x4_5_0);
		X.v[3] ^= X.v[0];
		X.v[2] += X.v[1];
		X.v[1] = RotL_32(X.v[1], R_32x4_5_1);
		X.v[1] ^= X.v[2];
	} if (Nrounds > 6) {
		X.v[0] += X.v[1];
		X.v[1] = RotL_32(X.v[1], R_32x4_6_0);
		X.v[1] ^= X.v[0];
		X.v[2] += X.v[3];
		X.v[3] = RotL_32(X.v[3], R_32x4_6_1);
		X.v[3] ^= X.v[2];
	} if (Nrounds > 7) {
		X.v[0] += X.v[3];
		X.v[3] = RotL_32(X.v[3], R_32x4_7_0);
		X.v[3] ^= X.v[0];
		X.v[2] += X.v[1];
		X.v[1] = RotL_32(X.v[1], R_32x4_7_1);
		X.v[1] ^= X.v[2];
	} if (Nrounds > 7) {
		X.v[0] += ks[2];
		X.v[1] += ks[3];
		X.v[2] += ks[4];
		X.v[3] += ks[0];
		X.v[4 - 1] += 2;
	} if (Nrounds > 8) {
		X.v[0] += X.v[1];
		X.v[1] = RotL_32(X.v[1], R_32x4_0_0);
		X.v[1] ^= X.v[0];
		X.v[2] += X.v[3];
		X.v[3] = RotL_32(X.v[3], R_32x4_0_1);
		X.v[3] ^= X.v[2];
	} if (Nrounds > 9) {
		X.v[0] += X.v[3];
		X.v[3] = RotL_32(X.v[3], R_32x4_1_0);
		X.v[3] ^= X.v[0];
		X.v[2] += X.v[1];
		X.v[1] = RotL_32(X.v[1], R_32x4_1_1);
		X.v[1] ^= X.v[2];
	} if (Nrounds > 10) {
		X.v[0] += X.v[1];
		X.v[1] = RotL_32(X.v[1], R_32x4_2_0);
		X.v[1] ^= X.v[0];
		X.v[2] += X.v[3];
		X.v[3] = RotL_32(X.v[3], R_32x4_2_1);
		X.v[3] ^= X.v[2];
	} if (Nrounds > 11) {
		X.v[0] += X.v[3];
		X.v[3] = RotL_32(X.v[3], R_32x4_3_0);
		X.v[3] ^= X.v[0];
		X.v[2] += X.v[1];
		X.v[1] = RotL_32(X.v[1], R_32x4_3_1);
		X.v[1] ^= X.v[2];
	} if (Nrounds > 11) {
		X.v[0] += ks[3];
		X.v[1] += ks[4];
		X.v[2] += ks[0];
		X.v[3] += ks[1];
		X.v[4 - 1] += 3;
	} if (Nrounds > 12) {
		X.v[0] += X.v[1];
		X.v[1] = RotL_32(X.v[1], R_32x4_4_0);
		X.v[1] ^= X.v[0];
		X.v[2] += X.v[3];
		X.v[3] = RotL_32(X.v[3], R_32x4_4_1);
		X.v[3] ^= X.v[2];
	} if (Nrounds > 13) {
		X.v[0] += X.v[3];
		X.v[3] = RotL_32(X.v[3], R_32x4_5_0);
		X.v[3] ^= X.v[0];
		X.v[2] += X.v[1];
		X.v[1] = RotL_32(X.v[1], R_32x4_5_1);
		X.v[1] ^= X.v[2];
	} if (Nrounds > 14) {
		X.v[0] += X.v[1];
		X.v[1] = RotL_32(X.v[1], R_32x4_6_0);
		X.v[1] ^= X.v[0];
		X.v[2] += X.v[3];
		X.v[3] = RotL_32(X.v[3], R_32x4_6_1);
		X.v[3] ^= X.v[2];
	} if (Nrounds > 15) {
		X.v[0] += X.v[3];
		X.v[3] = RotL_32(X.v[3], R_32x4_7_0);
		X.v[3] ^= X.v[0];
		X.v[2] += X.v[1];
		X.v[1] = RotL_32(X.v[1], R_32x4_7_1);
		X.v[1] ^= X.v[2];
	} if (Nrounds > 15) {
		X.v[0] += ks[4];
		X.v[1] += ks[0];
		X.v[2] += ks[1];
		X.v[3] += ks[2];
		X.v[4 - 1] += 4;
	} if (Nrounds > 16) {
		X.v[0] += X.v[1];
		X.v[1] = RotL_32(X.v[1], R_32x4_0_0);
		X.v[1] ^= X.v[0];
		X.v[2] += X.v[3];
		X.v[3] = RotL_32(X.v[3], R_32x4_0_1);
		X.v[3] ^= X.v[2];
	} if (Nrounds > 17) {
		X.v[0] += X.v[3];
		X.v[3] = RotL_32(X.v[3], R_32x4_1_0);
		X.v[3] ^= X.v[0];
		X.v[2] += X.v[1];
		X.v[1] = RotL_32(X.v[1], R_32x4_1_1);
		X.v[1] ^= X.v[2];
	} if (Nrounds > 18) {
		X.v[0] += X.v[1];
		X.v[1] = RotL_32(X.v[1], R_32x4_2_0);
		X.v[1] ^= X.v[0];
		X.v[2] += X.v[3];
		X.v[3] = RotL_32(X.v[3], R_32x4_2_1);
		X.v[3] ^= X.v[2];
	} if (Nrounds > 19) {
		X.v[0] += X.v[3];
		X.v[3] = RotL_32(X.v[3], R_32x4_3_0);
		X.v[3] ^= X.v[0];
		X.v[2] += X.v[1];
		X.v[1] = RotL_32(X.v[1], R_32x4_3_1);
		X.v[1] ^= X.v[2];
	} if (Nrounds > 19) {
		X.v[0] += ks[0];
		X.v[1] += ks[1];
		X.v[2] += ks[2];
		X.v[3] += ks[3];
		X.v[4 - 1] += 5;
	} if (Nrounds > 20) {
		X.v[0] += X.v[1];
		X.v[1] = RotL_32(X.v[1], R_32x4_4_0);
		X.v[1] ^= X.v[0];
		X.v[2] += X.v[3];
		X.v[3] = RotL_32(X.v[3], R_32x4_4_1);
		X.v[3] ^= X.v[2];
	} if (Nrounds > 21) {
		X.v[0] += X.v[3];
		X.v[3] = RotL_32(X.v[3], R_32x4_5_0);
		X.v[3] ^= X.v[0];
		X.v[2] += X.v[1];
		X.v[1] = RotL_32(X.v[1], R_32x4_5_1);
		X.v[1] ^= X.v[2];
	} if (Nrounds > 22) {
		X.v[0] += X.v[1];
		X.v[1] = RotL_32(X.v[1], R_32x4_6_0);
		X.v[1] ^= X.v[0];
		X.v[2] += X.v[3];
		X.v[3] = RotL_32(X.v[3], R_32x4_6_1);
		X.v[3] ^= X.v[2];
	} if (Nrounds > 23) {
		X.v[0] += X.v[3];
		X.v[3] = RotL_32(X.v[3], R_32x4_7_0);
		X.v[3] ^= X.v[0];
		X.v[2] += X.v[1];
		X.v[1] = RotL_32(X.v[1], R_32x4_7_1);
		X.v[1] ^= X.v[2];
	} if (Nrounds > 23) {
		X.v[0] += ks[1];
		X.v[1] += ks[2];
		X.v[2] += ks[3];
		X.v[3] += ks[4];
		X.v[4 - 1] += 6;
	} if (Nrounds > 24) {
		X.v[0] += X.v[1];
		X.v[1] = RotL_32(X.v[1], R_32x4_0_0);
		X.v[1] ^= X.v[0];
		X.v[2] += X.v[3];
		X.v[3] = RotL_32(X.v[3], R_32x4_0_1);
		X.v[3] ^= X.v[2];
	} if (Nrounds > 25) {
		X.v[0] += X.v[3];
		X.v[3] = RotL_32(X.v[3], R_32x4_1_0);
		X.v[3] ^= X.v[0];
		X.v[2] += X.v[1];
		X.v[1] = RotL_32(X.v[1], R_32x4_1_1);
		X.v[1] ^= X.v[2];
	} if (Nrounds > 26) {
		X.v[0] += X.v[1];
		X.v[1] = RotL_32(X.v[1], R_32x4_2_0);
		X.v[1] ^= X.v[0];
		X.v[2] += X.v[3];
		X.v[3] = RotL_32(X.v[3], R_32x4_2_1);
		X.v[3] ^= X.v[2];
	} if (Nrounds > 27) {
		X.v[0] += X.v[3];
		X.v[3] = RotL_32(X.v[3], R_32x4_3_0);
		X.v[3] ^= X.v[0];
		X.v[2] += X.v[1];
		X.v[1] = RotL_32(X.v[1], R_32x4_3_1);
		X.v[1] ^= X.v[2];
	} if (Nrounds > 27) {
		X.v[0] += ks[2];
		X.v[1] += ks[3];
		X.v[2] += ks[4];
		X.v[3] += ks[0];
		X.v[4 - 1] += 7;
	} if (Nrounds > 28) {
		X.v[0] += X.v[1];
		X.v[1] = RotL_32(X.v[1], R_32x4_4_0);
		X.v[1] ^= X.v[0];
		X.v[2] += X.v[3];
		X.v[3] = RotL_32(X.v[3], R_32x4_4_1);
		X.v[3] ^= X.v[2];
	} if (Nrounds > 29) {
		X.v[0] += X.v[3];
		X.v[3] = RotL_32(X.v[3], R_32x4_5_0);
		X.v[3] ^= X.v[0];
		X.v[2] += X.v[1];
		X.v[1] = RotL_32(X.v[1], R_32x4_5_1);
		X.v[1] ^= X.v[2];
	} if (Nrounds > 30) {
		X.v[0] += X.v[1];
		X.v[1] = RotL_32(X.v[1], R_32x4_6_0);
		X.v[1] ^= X.v[0];
		X.v[2] += X.v[3];
		X.v[3] = RotL_32(X.v[3], R_32x4_6_1);
		X.v[3] ^= X.v[2];
	} if (Nrounds > 31) {
		X.v[0] += X.v[3];
		X.v[3] = RotL_32(X.v[3], R_32x4_7_0);
		X.v[3] ^= X.v[0];
		X.v[2] += X.v[1];
		X.v[1] = RotL_32(X.v[1], R_32x4_7_1);
		X.v[1] ^= X.v[2];
	} if (Nrounds > 31) {
		X.v[0] += ks[3];
		X.v[1] += ks[4];
		X.v[2] += ks[0];
		X.v[3] += ks[1];
		X.v[4 - 1] += 8;
	} if (Nrounds > 32) {
		X.v[0] += X.v[1];
		X.v[1] = RotL_32(X.v[1], R_32x4_0_0);
		X.v[1] ^= X.v[0];
		X.v[2] += X.v[3];
		X.v[3] = RotL_32(X.v[3], R_32x4_0_1);
		X.v[3] ^= X.v[2];
	} if (Nrounds > 33) {
		X.v[0] += X.v[3];
		X.v[3] = RotL_32(X.v[3], R_32x4_1_0);
		X.v[3] ^= X.v[0];
		X.v[2] += X.v[1];
		X.v[1] = RotL_32(X.v[1], R_32x4_1_1);
		X.v[1] ^= X.v[2];
	} if (Nrounds > 34) {
		X.v[0] += X.v[1];
		X.v[1] = RotL_32(X.v[1], R_32x4_2_0);
		X.v[1] ^= X.v[0];
		X.v[2] += X.v[3];
		X.v[3] = RotL_32(X.v[3], R_32x4_2_1);
		X.v[3] ^= X.v[2];
	} if (Nrounds > 35) {
		X.v[0] += X.v[3];
		X.v[3] = RotL_32(X.v[3], R_32x4_3_0);
		X.v[3] ^= X.v[0];
		X.v[2] += X.v[1];
		X.v[1] = RotL_32(X.v[1], R_32x4_3_1);
		X.v[1] ^= X.v[2];
	} if (Nrounds > 35) {
		X.v[0] += ks[4];
		X.v[1] += ks[0];
		X.v[2] += ks[1];
		X.v[3] += ks[2];
		X.v[4 - 1] += 9;
	} if (Nrounds > 36) {
		X.v[0] += X.v[1];
		X.v[1] = RotL_32(X.v[1], R_32x4_4_0);
		X.v[1] ^= X.v[0];
		X.v[2] += X.v[3];
		X.v[3] = RotL_32(X.v[3], R_32x4_4_1);
		X.v[3] ^= X.v[2];
	} if (Nrounds > 37) {
		X.v[0] += X.v[3];
		X.v[3] = RotL_32(X.v[3], R_32x4_5_0);
		X.v[3] ^= X.v[0];
		X.v[2] += X.v[1];
		X.v[1] = RotL_32(X.v[1], R_32x4_5_1);
		X.v[1] ^= X.v[2];
	} if (Nrounds > 38) {
		X.v[0] += X.v[1];
		X.v[1] = RotL_32(X.v[1], R_32x4_6_0);
		X.v[1] ^= X.v[0];
		X.v[2] += X.v[3];
		X.v[3] = RotL_32(X.v[3], R_32x4_6_1);
		X.v[3] ^= X.v[2];
	} if (Nrounds > 39) {
		X.v[0] += X.v[3];
		X.v[3] = RotL_32(X.v[3], R_32x4_7_0);
		X.v[3] ^= X.v[0];
		X.v[2] += X.v[1];
		X.v[1] = RotL_32(X.v[1], R_32x4_7_1);
		X.v[1] ^= X.v[2];
	} if (Nrounds > 39) {
		X.v[0] += ks[0];
		X.v[1] += ks[1];
		X.v[2] += ks[2];
		X.v[3] += ks[3];
		X.v[4 - 1] += 10;
	} if (Nrounds > 40) {
		X.v[0] += X.v[1];
		X.v[1] = RotL_32(X.v[1], R_32x4_0_0);
		X.v[1] ^= X.v[0];
		X.v[2] += X.v[3];
		X.v[3] = RotL_32(X.v[3], R_32x4_0_1);
		X.v[3] ^= X.v[2];
	} if (Nrounds > 41) {
		X.v[0] += X.v[3];
		X.v[3] = RotL_32(X.v[3], R_32x4_1_0);
		X.v[3] ^= X.v[0];
		X.v[2] += X.v[1];
		X.v[1] = RotL_32(X.v[1], R_32x4_1_1);
		X.v[1] ^= X.v[2];
	} if (Nrounds > 42) {
		X.v[0] += X.v[1];
		X.v[1] = RotL_32(X.v[1], R_32x4_2_0);
		X.v[1] ^= X.v[0];
		X.v[2] += X.v[3];
		X.v[3] = RotL_32(X.v[3], R_32x4_2_1);
		X.v[3] ^= X.v[2];
	} if (Nrounds > 43) {
		X.v[0] += X.v[3];
		X.v[3] = RotL_32(X.v[3], R_32x4_3_0);
		X.v[3] ^= X.v[0];
		X.v[2] += X.v[1];
		X.v[1] = RotL_32(X.v[1], R_32x4_3_1);
		X.v[1] ^= X.v[2];
	} if (Nrounds > 43) {
		X.v[0] += ks[1];
		X.v[1] += ks[2];
		X.v[2] += ks[3];
		X.v[3] += ks[4];
		X.v[4 - 1] += 11;
	} if (Nrounds > 44) {
		X.v[0] += X.v[1];
		X.v[1] = RotL_32(X.v[1], R_32x4_4_0);
		X.v[1] ^= X.v[0];
		X.v[2] += X.v[3];
		X.v[3] = RotL_32(X.v[3], R_32x4_4_1);
		X.v[3] ^= X.v[2];
	} if (Nrounds > 45) {
		X.v[0] += X.v[3];
		X.v[3] = RotL_32(X.v[3], R_32x4_5_0);
		X.v[3] ^= X.v[0];
		X.v[2] += X.v[1];
		X.v[1] = RotL_32(X.v[1], R_32x4_5_1);
		X.v[1] ^= X.v[2];
	} if (Nrounds > 46) {
		X.v[0] += X.v[1];
		X.v[1] = RotL_32(X.v[1], R_32x4_6_0);
		X.v[1] ^= X.v[0];
		X.v[2] += X.v[3];
		X.v[3] = RotL_32(X.v[3], R_32x4_6_1);
		X.v[3] ^= X.v[2];
	} if (Nrounds > 47) {
		X.v[0] += X.v[3];
		X.v[3] = RotL_32(X.v[3], R_32x4_7_0);
		X.v[3] ^= X.v[0];
		X.v[2] += X.v[1];
		X.v[1] = RotL_32(X.v[1], R_32x4_7_1);
		X.v[1] ^= X.v[2];
	} if (Nrounds > 47) {
		X.v[0] += ks[2];
		X.v[1] += ks[3];
		X.v[2] += ks[4];
		X.v[3] += ks[0];
		X.v[4 - 1] += 12;
	} if (Nrounds > 48) {
		X.v[0] += X.v[1];
		X.v[1] = RotL_32(X.v[1], R_32x4_0_0);
		X.v[1] ^= X.v[0];
		X.v[2] += X.v[3];
		X.v[3] = RotL_32(X.v[3], R_32x4_0_1);
		X.v[3] ^= X.v[2];
	} if (Nrounds > 49) {
		X.v[0] += X.v[3];
		X.v[3] = RotL_32(X.v[3], R_32x4_1_0);
		X.v[3] ^= X.v[0];
		X.v[2] += X.v[1];
		X.v[1] = RotL_32(X.v[1], R_32x4_1_1);
		X.v[1] ^= X.v[2];
	} if (Nrounds > 50) {
		X.v[0] += X.v[1];
		X.v[1] = RotL_32(X.v[1], R_32x4_2_0);
		X.v[1] ^= X.v[0];
		X.v[2] += X.v[3];
		X.v[3] = RotL_32(X.v[3], R_32x4_2_1);
		X.v[3] ^= X.v[2];
	} if (Nrounds > 51) {
		X.v[0] += X.v[3];
		X.v[3] = RotL_32(X.v[3], R_32x4_3_0);
		X.v[3] ^= X.v[0];
		X.v[2] += X.v[1];
		X.v[1] = RotL_32(X.v[1], R_32x4_3_1);
		X.v[1] ^= X.v[2];
	} if (Nrounds > 51) {
		X.v[0] += ks[3];
		X.v[1] += ks[4];
		X.v[2] += ks[0];
		X.v[3] += ks[1];
		X.v[4 - 1] += 13;
	} if (Nrounds > 52) {
		X.v[0] += X.v[1];
		X.v[1] = RotL_32(X.v[1], R_32x4_4_0);
		X.v[1] ^= X.v[0];
		X.v[2] += X.v[3];
		X.v[3] = RotL_32(X.v[3], R_32x4_4_1);
		X.v[3] ^= X.v[2];
	} if (Nrounds > 53) {
		X.v[0] += X.v[3];
		X.v[3] = RotL_32(X.v[3], R_32x4_5_0);
		X.v[3] ^= X.v[0];
		X.v[2] += X.v[1];
		X.v[1] = RotL_32(X.v[1], R_32x4_5_1);
		X.v[1] ^= X.v[2];
	} if (Nrounds > 54) {
		X.v[0] += X.v[1];
		X.v[1] = RotL_32(X.v[1], R_32x4_6_0);
		X.v[1] ^= X.v[0];
		X.v[2] += X.v[3];
		X.v[3] = RotL_32(X.v[3], R_32x4_6_1);
		X.v[3] ^= X.v[2];
	} if (Nrounds > 55) {
		X.v[0] += X.v[3];
		X.v[3] = RotL_32(X.v[3], R_32x4_7_0);
		X.v[3] ^= X.v[0];
		X.v[2] += X.v[1];
		X.v[1] = RotL_32(X.v[1], R_32x4_7_1);
		X.v[1] ^= X.v[2];
	} if (Nrounds > 55) {
		X.v[0] += ks[4];
		X.v[1] += ks[0];
		X.v[2] += ks[1];
		X.v[3] += ks[2];
		X.v[4 - 1] += 14;
	} if (Nrounds > 56) {
		X.v[0] += X.v[1];
		X.v[1] = RotL_32(X.v[1], R_32x4_0_0);
		X.v[1] ^= X.v[0];
		X.v[2] += X.v[3];
		X.v[3] = RotL_32(X.v[3], R_32x4_0_1);
		X.v[3] ^= X.v[2];
	} if (Nrounds > 57) {
		X.v[0] += X.v[3];
		X.v[3] = RotL_32(X.v[3], R_32x4_1_0);
		X.v[3] ^= X.v[0];
		X.v[2] += X.v[1];
		X.v[1] = RotL_32(X.v[1], R_32x4_1_1);
		X.v[1] ^= X.v[2];
	} if (Nrounds > 58) {
		X.v[0] += X.v[1];
		X.v[1] = RotL_32(X.v[1], R_32x4_2_0);
		X.v[1] ^= X.v[0];
		X.v[2] += X.v[3];
		X.v[3] = RotL_32(X.v[3], R_32x4_2_1);
		X.v[3] ^= X.v[2];
	} if (Nrounds > 59) {
		X.v[0] += X.v[3];
		X.v[3] = RotL_32(X.v[3], R_32x4_3_0);
		X.v[3] ^= X.v[0];
		X.v[2] += X.v[1];
		X.v[1] = RotL_32(X.v[1], R_32x4_3_1);
		X.v[1] ^= X.v[2];
	} if (Nrounds > 59) {
		X.v[0] += ks[0];
		X.v[1] += ks[1];
		X.v[2] += ks[2];
		X.v[3] += ks[3];
		X.v[4 - 1] += 15;
	} if (Nrounds > 60) {
		X.v[0] += X.v[1];
		X.v[1] = RotL_32(X.v[1], R_32x4_4_0);
		X.v[1] ^= X.v[0];
		X.v[2] += X.v[3];
		X.v[3] = RotL_32(X.v[3], R_32x4_4_1);
		X.v[3] ^= X.v[2];
	} if (Nrounds > 61) {
		X.v[0] += X.v[3];
		X.v[3] = RotL_32(X.v[3], R_32x4_5_0);
		X.v[3] ^= X.v[0];
		X.v[2] += X.v[1];
		X.v[1] = RotL_32(X.v[1], R_32x4_5_1);
		X.v[1] ^= X.v[2];
	} if (Nrounds > 62) {
		X.v[0] += X.v[1];
		X.v[1] = RotL_32(X.v[1], R_32x4_6_0);
		X.v[1] ^= X.v[0];
		X.v[2] += X.v[3];
		X.v[3] = RotL_32(X.v[3], R_32x4_6_1);
		X.v[3] ^= X.v[2];
	} if (Nrounds > 63) {
		X.v[0] += X.v[3];
		X.v[3] = RotL_32(X.v[3], R_32x4_7_0);
		X.v[3] ^= X.v[0];
		X.v[2] += X.v[1];
		X.v[1] = RotL_32(X.v[1], R_32x4_7_1);
		X.v[1] ^= X.v[2];
	} if (Nrounds > 63) {
		X.v[0] += ks[1];
		X.v[1] += ks[2];
		X.v[2] += ks[3];
		X.v[3] += ks[4];
		X.v[4 - 1] += 16;
	} if (Nrounds > 64) {
		X.v[0] += X.v[1];
		X.v[1] = RotL_32(X.v[1], R_32x4_0_0);
		X.v[1] ^= X.v[0];
		X.v[2] += X.v[3];
		X.v[3] = RotL_32(X.v[3], R_32x4_0_1);
		X.v[3] ^= X.v[2];
	} if (Nrounds > 65) {
		X.v[0] += X.v[3];
		X.v[3] = RotL_32(X.v[3], R_32x4_1_0);
		X.v[3] ^= X.v[0];
		X.v[2] += X.v[1];
		X.v[1] = RotL_32(X.v[1], R_32x4_1_1);
		X.v[1] ^= X.v[2];
	} if (Nrounds > 66) {
		X.v[0] += X.v[1];
		X.v[1] = RotL_32(X.v[1], R_32x4_2_0);
		X.v[1] ^= X.v[0];
		X.v[2] += X.v[3];
		X.v[3] = RotL_32(X.v[3], R_32x4_2_1);
		X.v[3] ^= X.v[2];
	} if (Nrounds > 67) {
		X.v[0] += X.v[3];
		X.v[3] = RotL_32(X.v[3], R_32x4_3_0);
		X.v[3] ^= X.v[0];
		X.v[2] += X.v[1];
		X.v[1] = RotL_32(X.v[1], R_32x4_3_1);
		X.v[1] ^= X.v[2];
	} if (Nrounds > 67) {
		X.v[0] += ks[2];
		X.v[1] += ks[3];
		X.v[2] += ks[4];
		X.v[3] += ks[0];
		X.v[4 - 1] += 17;
	} if (Nrounds > 68) {
		X.v[0] += X.v[1];
		X.v[1] = RotL_32(X.v[1], R_32x4_4_0);
		X.v[1] ^= X.v[0];
		X.v[2] += X.v[3];
		X.v[3] = RotL_32(X.v[3], R_32x4_4_1);
		X.v[3] ^= X.v[2];
	} if (Nrounds > 69) {
		X.v[0] += X.v[3];
		X.v[3] = RotL_32(X.v[3], R_32x4_5_0);
		X.v[3] ^= X.v[0];
		X.v[2] += X.v[1];
		X.v[1] = RotL_32(X.v[1], R_32x4_5_1);
		X.v[1] ^= X.v[2];
	} if (Nrounds > 70) {
		X.v[0] += X.v[1];
		X.v[1] = RotL_32(X.v[1], R_32x4_6_0);
		X.v[1] ^= X.v[0];
		X.v[2] += X.v[3];
		X.v[3] = RotL_32(X.v[3], R_32x4_6_1);
		X.v[3] ^= X.v[2];
	} if (Nrounds > 71) {
		X.v[0] += X.v[3];
		X.v[3] = RotL_32(X.v[3], R_32x4_7_0);
		X.v[3] ^= X.v[0];
		X.v[2] += X.v[1];
		X.v[1] = RotL_32(X.v[1], R_32x4_7_1);
		X.v[1] ^= X.v[2];
	} if (Nrounds > 71) {
		X.v[0] += ks[3];
		X.v[1] += ks[4];
		X.v[2] += ks[0];
		X.v[3] += ks[1];
		X.v[4 - 1] += 18;
	} 
	return X;
} 

template <class T>
__kernel void PRNG_threefry4x32(
        __global uint4 *randomnumber,
        threefry4x32_ctr_t ctr_i,
        T inf,
        T sup,
        T threshold,
        uint nrounds,
        uint numrandom
){
        size_t  gdx = get_global_id(0);

        uint maxUint = 0;
        maxUint--;
        float r = (float)maxUint;

        threefry4x32_ctr_t      ctr = ctr_i; 
        threefry4x32_ukey_t ukey;

        ukey.v[0] = ukey.v[1] = ukey.v[2] = ukey.v[3] = gdx;

        threefry4x32_ctr_t  random4;

        if ( gdx < numrandom )
        {
                random4 = threefry4x32_R(nrounds, ctr, ukey);
                uint4 frnd;
				
                frnd.x = ( (((float)random4.v[0]) / r) * (sup - inf) + inf ) > threshold? 1 : 0;
                frnd.y = ( (((float)random4.v[1]) / r) * (sup - inf) + inf ) > threshold? 1 : 0;
                frnd.z = ( (((float)random4.v[2]) / r) * (sup - inf) + inf ) > threshold? 1 : 0;
                frnd.w = ( (((float)random4.v[3]) / r) * (sup - inf) + inf ) > threshold? 1 : 0;
				
                randomnumber[gdx] = frnd;
        }
}


template __attribute__((mangled_name(RNGBernoulliFloat))) __kernel void PRNG_threefry4x32(__global uint4 *randomnumber, threefry4x32_ctr_t ctr_i, float inf, float sup, float threshold, uint nrounds, uint numrandonm);

template __attribute__((mangled_name(RNGBernoulliDouble))) __kernel void PRNG_threefry4x32(__global uint4 *randomnumber, threefry4x32_ctr_t ctr_i, double inf, double sup, double threshold, uint nrounds, uint numrandonm);

//end of the looooooong gpu_random_generator kernel 


template <class T>
__kernel void OCL_memset(__global T* buffer, const T value, const int size){
	int gdx = get_global_id(0);
	if(gdx < size){
		buffer[gdx] = value;	
	}
}

template __attribute__((mangled_name(oclmemfloat))) __kernel void OCL_memset(__global float* buffer, const float value, const int size);
template __attribute__((mangled_name(oclmemdouble))) __kernel void OCL_memset(__global double* buffer, const double value, const int size);

__kernel void OCL_memset2(__global int* buffer, const int value, const int size){
        int gdx = get_global_id(0);
        if(gdx < size){
                buffer[gdx] = value;    
        }
}

template <class T>
__kernel void caffe_gpu_sign(const int N, __global T* X, __global T* Y){
     int gdx = get_global_id(0);
     if(gdx < N){
          Y[gdx] =((0.0<X[gdx])-(X[gdx]<0.0));
     }
}

template __attribute__((mangled_name(caffe_gpu_sign_float))) __kernel void caffe_gpu_sign(const int N, __global float* X, __global float* Y);
template __attribute__((mangled_name(caffe_gpu_sign_double))) __kernel void caffe_gpu_sign(const int N, __global double* X, __global double* Y);

template <class T>
__kernel void im2col(const int n, __global T* data_im, const int img_offset, const int height, const int width, const int ksize, const int pad, const int stride, const int height_col, const int width_col, __global T* data_col, const int col_offset){
    int index=get_global_id(0);
    data_im = data_im + img_offset;
    data_col =  data_col + col_offset;
    if(index < n){
        int w_out=index %width_col;
        index /= width_col;
        int h_out=index%height_col;
        int channel_in = index/height_col;
        int channel_out=channel_in *ksize *ksize;
        int h_in = h_out *stride-pad;
        int w_in = w_out *stride-pad;
        data_col +=(channel_out *height_col + h_out) *width_col + w_out;
        data_im +=(channel_in * height + h_in) *width + w_in;
        int i=0,j=0;
        for(i=0;i<ksize;++i){
            for(j=0;j<ksize;++j){
                int h = h_in+i;
                int w = w_in+j;
                if(h >= 0 && w >= 0 && h < height && w < width)
                    *data_col=data_im[i * width + j];
                else *data_col=0;
                data_col +=height_col *width_col;
            }
        }
    }
}

template __attribute__((mangled_name(im2colfloat))) __kernel void im2col(const int n, __global float* data_im, const int img_offset, const int height, const int width, const int ksize, const int pad, const int stride, const int height_col, const int width_col, __global float* data_col, const int col_offset); 
template __attribute__((mangled_name(im2coldouble))) __kernel void im2col(const int n, __global double* data_im, const int img_offset, const int height, const int width, const int ksize, const int pad, const int stride, const int height_col, const int width_col, __global double* data_col, const int col_offset); 

template <class T>
__kernel void im2col_opt(const int n, __global T* data_im, const int channels, const int img_offset, const int height, const int width, const int ksize, const int pad, const int stride, const int height_col, const int width_col, __global T* data_col, const int col_offset, const int optnum){

    int index = get_global_id(0);

    data_im = data_im + img_offset;
    data_col = data_col + col_offset;

    int x_out = index % width_col;
    int y_out = (index / width_col) % height_col;
    int channel_in = (index / width_col / height_col) % channels;
    int channel_out = channel_in * ksize * ksize;
    int im_id = index / width_col / height_col / channels;

    int y_in = y_out * stride - pad;
    int x_in = x_out * stride - pad;
    int offset_col = channel_out * optnum * height_col * width_col + im_id * height_col * width_col;
    int offset_im = im_id * channels * height * width + channel_in * height * width;

    for(int k_h = 0; k_h < ksize; k_h++){
        for(int k_w = 0; k_w < ksize; k_w++){
            int x_im = x_in + k_w;
            int y_im = y_in + k_h;
            int index_im = y_im * width + x_im;
            int index_col = (k_h * ksize + k_w) * optnum * height_col * width_col + y_out * width_col + x_out;
            if(y_im >= 0 && y_im < height && x_im >= 0 && x_im < width)
                data_col[offset_col + index_col] = data_im[offset_im + index_im];
            else
                data_col[offset_col + index_col] = 0;
        }
    }
}

template __attribute__((mangled_name(im2col_optfloat))) __kernel void im2col_opt(const int n, __global float* data_im, const int channels, const int lmg_offset, const int height, const int width, const int ksize, const int pad, const int stride, const int height_col, const int width_col, __global float* data_col, const int col_offset, const int optnum); 
template __attribute__((mangled_name(im2col_optdouble))) __kernel void im2col_opt(const int n, __global double* data_im, const int channels, const int img_offset, const int height, const int width, const int ksize, const int pad, const int stride, const int height_col, const int width_col, __global double* data_col, const int col_offset, const int optnum); 


template <class T>
__kernel void im2col_gpu_kernel(const int n, __global const T* data_im, const int img_offset,
    const int height, const int width, const int kernel_h, const int kernel_w,
    const int pad_h, const int pad_w,
    const int stride_h, const int stride_w,
    const int height_col, const int width_col,
    __global T* data_col, const int col_offset) {
    data_im = data_im + img_offset;
    data_col = data_col + col_offset;     

    int index = get_global_id(0);
    if(index < n) {
        int w_out = index % width_col;
        int h_index = index / width_col;
        int h_out = h_index % height_col;
        int channel_in = h_index / height_col;
        int channel_out = channel_in * kernel_h * kernel_w;
        int h_in = h_out * stride_h - pad_h;
        int w_in = w_out * stride_w - pad_w;
        __global T* data_col_ptr = data_col;
        data_col_ptr += (channel_out * height_col + h_out) * width_col + w_out;
        __global const T* data_im_ptr = data_im;
        data_im_ptr += (channel_in * height + h_in) * width + w_in;
        for (int i = 0; i < kernel_h; ++i) {
            for (int j = 0; j < kernel_w; ++j) {
                int h = h_in + i;
                int w = w_in + j;
                *data_col_ptr = (h >= 0 && w >= 0 && h < height && w < width) ?
                            data_im_ptr[i * width + j] : 0;
                data_col_ptr += height_col * width_col;
        }
    }
  }
}

template __attribute__((mangled_name(im2col_gpu_float_kernel))) void im2col_gpu_kernel<float>(const int n, __global const float* data_im,
           const int img_offset, const int height, const int width, const int kernel_h, const int kernel_w,
           const int pad_h, const int pad_w, const int stride_h, const int stride_w,
           const int height_col, const int width_col, __global float* data_col, const int col_offset);
template __attribute__((mangled_name(im2col_gpu_double_kernel)))  void im2col_gpu_kernel<double>(const int n, __global const double* data_im,
           const int img_offset, const int height, const int width, const int kernel_h, const int kernel_w,
           const int pad_h, const int pad_w, const int stride_h, const int stride_w,
           const int height_col, const int width_col, __global double* data_col, const int col_offset);

template <class T>
__kernel void col2im_gpu_kernel(const int n, __global const T* data_col, const int col_offset,
    const int height, const int width, const int channels,
    const int patch_h, const int patch_w,
    const int pad_h, const int pad_w,
    const int stride_h, const int stride_w,
    const int height_col, const int width_col,
    __global T* data_im, const int img_offset) {
    data_col = data_col + col_offset;
    data_im = data_im + img_offset;
   int index = get_global_id(0);
    if(index < n) {
        T val = 0;
        int w = index % width + pad_w;
        int h = (index / width) % height + pad_h;
        int c = index / (width * height);
        // compute the start and end of the output
        int w_col_start = (w < patch_w) ? 0 : (w - patch_w) / stride_w + 1;
        int w_col_end = min(w / stride_w + 1, width_col);
        int h_col_start = (h < patch_h) ? 0 : (h - patch_h) / stride_h + 1;
        int h_col_end = min(h / stride_h + 1, height_col);
        // equivalent implementation
        int offset =
            (c * patch_h * patch_w + h * patch_w + w) * height_col * width_col;
        int coeff_h_col = (1 - stride_h * patch_w * height_col) * width_col;
        int coeff_w_col = (1 - stride_w * height_col * width_col);
        for (int h_col = h_col_start; h_col < h_col_end; ++h_col) {
            for (int w_col = w_col_start; w_col < w_col_end; ++w_col) {
                val += data_col[offset + h_col * coeff_h_col + w_col * coeff_w_col];
            }
        }
        data_im[index] = val;
  }
}

template __attribute__((mangled_name(col2im_gpu_float_kernel))) __kernel void col2im_gpu_kernel(const int n, __global const float* data_col, const int col_offset,
    									const int height, const int width, const int channels,
    									const int patch_h, const int patch_w,const int pad_h, const int pad_w,
    									const int stride_h, const int stride_w,const int height_col, const int width_col,
    									__global float* data_im, const int img_offset);
template __attribute__((mangled_name(col2im_gpu_double_kernel))) __kernel void col2im_gpu_kernel(const int n, __global const double* data_col,
                                         const int col_offset, const int height, const int width, const int channels,
                                         const int patch_h, const int patch_w, const int pad_h, const int pad_w,
                                         const int stride_h, const int stride_w, const int height_col, const int width_col, __global double* data_im, const int img_offset);

template <class T>
__kernel void col2im(const int n, __global T* data_col, const int col_offset, const int height, const int width, const int channels, const int ksize, const int pad, const int stride, const int height_col, const int width_col, __global T* data_im, const int img_offset){
    int index = get_global_id(0);
    data_col = data_col + col_offset;
    data_im = data_im + img_offset;
    if(index < n){
      T val = 0;
      int w = index % width + pad;
      int h = (index / width) % height + pad;
      int c = index / (width * height);
      // compute the start and end of the output
      int w_col_start = (w < ksize) ? 0 : (w - ksize) / stride + 1;
      int w_col_end = min(w / stride + 1, width_col);
      int h_col_start = (h < ksize) ? 0 : (h - ksize) / stride + 1;
      int h_col_end = min(h / stride + 1, height_col);
      // equivalent implementation
      int offset = (c * ksize * ksize + h * ksize + w) * height_col * width_col;
      int coeff_h_col = (1 - stride * ksize * height_col) * width_col;
      int coeff_w_col = (1 - stride * height_col * width_col);
      for (int h_col = h_col_start; h_col < h_col_end; ++h_col) {
        for (int w_col = w_col_start; w_col < w_col_end; ++w_col) {
          val += data_col[offset + h_col * coeff_h_col + w_col * coeff_w_col];
        }
      }
      data_im[index] = val;
  }
}
template __attribute__((mangled_name(col2imfloat))) __kernel void col2im(const int n, __global float* data_col, const int col_offset, const int height, const int width, const int channels, const int ksize, const int pad, const int stride, const int height_col, const int width_col, __global float* data_im, const int img_offset); 
template __attribute__((mangled_name(col2imdouble))) __kernel void col2im(const int n, __global double* data_col, const int col_offset, const int height, const int width, const int channels, const int ksize, const int pad, const int stride, const int height_col, const int width_col, __global double* data_im, const int img_offset); 

template <class T>
__kernel void im2col_yuan(const int n,__global T* data_im, const int height, const int width, const int ksize, const int pad, const int stride, const int height_col, const int width_col, __global T* data_col){
    int index = get_global_id(0);
    int tmp = get_global_size(0);
    for(index;index<n;index+=tmp){
        int w_out=index %width_col;
        index /= width_col;
        int h_out=index%height_col;
        int channel_in = index/height_col;
        int channel_out=channel_in *ksize *ksize;
        int h_in = h_out *stride-pad;
        int w_in = w_out *stride-pad;
        data_col +=(channel_out *height_col + h_out) *width_col + w_out;
        data_im +=(channel_in * height + h_in) *width + w_in;
        int i=0,j=0;
        for(i=0;i<ksize;++i){
            for(j=0;j<ksize;++j){
                int h = h_in+i;
                int w = w_in+j;
                if(h >= 0 && w >= 0 && h < height && w < width)
                    *data_col=data_im[i * width + j];
                else *data_col=0;
                data_col += height_col *width_col;
            }
        }
    }
}

template __attribute__((mangled_name(im2colfloat_yuan))) __kernel void im2col_yuan(const int n,__global float* data_im, const int height, const int width, const int ksize, const int pad, const int stride, const int height_col, const int width_col, __global float* data_col); 
template __attribute__((mangled_name(im2coldouble_yuan))) __kernel void im2col_yuan(const int n,__global double* data_im, const int height, const int width, const int ksize, const int pad, const int stride, const int height_col, const int width_col, __global double* data_col); 

template <class T>
__kernel void col2im_opt(const int n, __global T* data_col, const int col_offset, const int height, const int width, const int channels, const int ksize, const int pad, const int stride, const int height_col, const int width_col, __global T* data_im, const int img_offset, const int optnum){
    int index = get_global_id(0);
    data_col = data_col + col_offset;
    data_im = data_im + img_offset;
    if(index < n){
      T val = 0;
      int w = index % width + pad;
      int h = (index / width) % height + pad;
      int c = index / (width * height) % channels;
      int im = index / width / height / channels;
      // compute the start and end of the output
      int w_col_start = (w < ksize) ? 0 : (w - ksize) / stride + 1;
      int w_col_end = min(w / stride + 1, width_col);
      int h_col_start = (h < ksize) ? 0 : (h - ksize) / stride + 1;
      int h_col_end = min(h / stride + 1, height_col);
      // equivalent implementation
      int offset = (c * ksize * ksize + h * ksize + w) * height_col * width_col * optnum + im * height_col * width_col;
      int coeff_h_col = (1 - stride * ksize * height_col * optnum) * width_col;
      int coeff_w_col = (1 - stride * height_col * width_col * optnum);
      for (int h_col = h_col_start; h_col < h_col_end; ++h_col) {
        for (int w_col = w_col_start; w_col < w_col_end; ++w_col) {
          val += data_col[offset + h_col * coeff_h_col + w_col * coeff_w_col];
        }
      }
      data_im[index] = val;
  }
}
template __attribute__((mangled_name(col2im_optfloat))) __kernel void col2im_opt(const int n, __global float* data_col, const int col_offset, const int height, const int width, const int channels, const int ksize, const int pad, const int stride, const int height_col, const int width_col, __global float* data_im, const int img_offset, const int optnum); 
template __attribute__((mangled_name(col2im_optdouble))) __kernel void col2im_opt(const int n, __global double* data_col, const int col_offset, const int height, const int width, const int channels, const int ksize, const int pad, const int stride, const int height_col, const int width_col, __global double* data_im, const int img_offset, const int optnum); 


template <class T>
__kernel void col2im_yuan(const int n,__global T* data_col, const int height, const int width, const int channels, const int ksize, const int pad, const int stride, const int height_col, const int width_col, __global T* data_im){
    int index = get_global_id(0);
    int tmp = get_global_size(0);
    for(index; index < n; index += tmp){
      T val = 0;
      int w = index % width + pad;
      int h = (index / width) % height + pad;
      int c = index / (width * height);
      // compute the start and end of the output
      int w_col_start = (w < ksize) ? 0 : (w - ksize) / stride + 1;
      int w_col_end = min(w / stride + 1, width_col);
      int h_col_start = (h < ksize) ? 0 : (h - ksize) / stride + 1;
      int h_col_end = min(h / stride + 1, height_col);
      // equivalent implementation
      int offset = (c * ksize * ksize + h * ksize + w) * height_col * width_col;
      int coeff_h_col = (1 - stride * ksize * height_col) * width_col;
      int coeff_w_col = (1 - stride * height_col * width_col);
      for (int h_col = h_col_start; h_col < h_col_end; ++h_col) {
        for (int w_col = w_col_start; w_col < w_col_end; ++w_col) {
          val += data_col[offset + h_col * coeff_h_col + w_col * coeff_w_col];
        }
      }
      data_im[index] = val;
  }
}
template __attribute__((mangled_name(col2imfloat_yuan))) __kernel void col2im_yuan(const int n,__global float* data_col, const int height, const int width, const int channels, const int ksize, const int pad, const int stride, const int height_col, const int width_col, __global float* data_im); 
template __attribute__((mangled_name(col2imdouble_yuan))) __kernel void col2im_yuan(const int n,__global double* data_col, const int height, const int width, const int channels, const int ksize, const int pad, const int stride, const int height_col, const int width_col, __global double* data_im); 

template <class T>
__kernel void opttrans(const int n, __global T* data_im, const int im_offset, const int height, const int width, const int channels, __global T* data_opt, const int opt_offset, const int optnum){

    int index = get_global_id(0);
    data_opt = data_opt + opt_offset;
    data_im = data_im + im_offset;
    if(index < n){
      int w = index % width;
      int h = (index / width) % height;
      int c = index / (width * height) % channels;
      int im = index / width / height / channels;

      int opt_index = c * height * optnum * width + h * optnum * width + im * width + w;
      data_opt[opt_index] = data_im[index];
    }
}
template __attribute__((mangled_name(opttransfloat))) __kernel void opttrans(const int n, __global float* data_im, const int im_offset, const int height, const int width, const int channels, __global float* data_opt, const int opt_offset, const int optnum); 
template __attribute__((mangled_name(opttransdouble))) __kernel void opttrans(const int n, __global double* data_im, const int im_offset, const int height, const int width, const int channels, __global double* data_opt, const int opt_offset, const int optnum); 


template <class T>
__kernel void MaxPoolForward(const int nthreads, __global T* bottom_data, const int num, const int channels, const int height, const int width, const int pooled_height, const int pooled_width, const int kernel_h, const int kernel_w, const int stride_h, const int stride_w, const int pad_h, const int pad_w, __global T* top_data, __global int* mask, __global T* top_mask){
     int index = get_global_id(0);
     int tmp = get_global_size(0);
     for(index; index < nthreads; index += tmp){
         int pw = index % pooled_width;
         int ph = (index / pooled_width) % pooled_height;
         int c = (index / pooled_width / pooled_height) % channels;
         int n = index / pooled_width / pooled_height / channels;
         int hstart = ph * stride_h - pad_h;
         int wstart = pw * stride_w - pad_w;
         const int hend = min(hstart + kernel_h, height);
         const int wend = min(wstart + kernel_w, width);
         hstart = max(hstart, 0);
         wstart = max(wstart, 0);
        T maxval = -FLT_MAX;
        int maxidx = -1;
        bottom_data =
        bottom_data + (n * channels + c) * height * width;
        for (int h = hstart; h < hend; ++h) {
          for (int w = wstart; w < wend; ++w) {
           if (bottom_data[h * width + w] > maxval) {
             maxidx = h * width + w;
             maxval = bottom_data[maxidx];
        }
      }
    }
    top_data[index] = maxval;
    if (mask) {
      mask[index] = maxidx;
    } else {
      top_mask[index] = maxidx;
    }
  }
}
template __attribute__((mangled_name(MaxPoolForwardfloat))) __kernel void MaxPoolForward(const int nthreads, __global float* bottom_data, const int num, const int channels, const int height, const int width, const int pooled_height, const int pooled_width,const int kernel_h, const int kernel_w, const int stride_h, const int stride_w, const int pad_h, const int pad_w, __global float* top_data, __global int* mask, __global float* top_mask);
template __attribute__((mangled_name(MaxPoolForwarddouble))) __kernel void MaxPoolForward(const int nthreads, __global double* bottom_data, const int num, const int channels, const int height, const int width, const int pooled_height, const int pooled_width, const int kernel_h, const int kernel_w,  const int stride_h, const int stride_w, const int pad_h, const int pad_w, __global double* top_data, __global int* mask, __global double* top_mask);

template <class T>
__kernel void AvePoolForward(const int nthreads, __global T* bottom_data, const int num, const int channels, const int height, const int width, const int pooled_height, const int pooled_width, const int kernel_h, const int kernel_w, const int stride_h, const int stride_w, const int pad_h, const int pad_w,__global T* top_data){
    int index = get_global_id(0);
    int tmp = get_global_size(0);
    for(index; index < nthreads; index+=tmp){
        int pw = index % pooled_width;
        int ph = (index / pooled_width) % pooled_height;
        int c = (index / pooled_width / pooled_height) % channels;
        int n = index / pooled_width / pooled_height / channels;            int hstart = ph * stride_h - pad_h;            int wstart = pw * stride_w - pad_w;
            int hend = min(hstart + kernel_h, height + pad_h);
            int wend = min(wstart + kernel_w, width + pad_w);
            const int pool_size = (hend - hstart) * (wend - wstart);
            hstart = max(hstart, 0);
            wstart = max(wstart, 0);
            hend = min(hend, height);
            wend = min(wend, width);
            T aveval = 0;
            bottom_data =
                bottom_data + (n * channels + c) * height * width;
            for (int h = hstart; h < hend; ++h) {
              for (int w = wstart; w < wend; ++w) {
                aveval += bottom_data[h * width + w];
              }
            }
            top_data[index] = aveval / pool_size;
          }

}
template __attribute__((mangled_name(AvePoolForwardfloat))) __kernel void AvePoolForward(const int nthreads, __global float* bottom_data, const int num, const int channels, const int height, const int width, const int pooled_height, const int pooled_width, const int kernel_h, const int kernel_w, const int stride_h, const int stride_w, const int pad_h, const int pad_w,__global float* top_data);
template __attribute__((mangled_name(AvePoolForwarddouble))) __kernel void AvePoolForward(const int nthreads, __global double* bottom_data, const int num, const int channels, const int height, const int width, const int pooled_height, const int pooled_width, const int kernel_h, const int kernel_w, const int stride_h, const int stride_w, const int pad_h, const int pad_w,__global double* top_data);

template <class T>
__kernel void StoPoolForwardTrain(const int nthreads, __global T* bottom_data, const int clnum, const int channels, const int height, const int width, const int pooled_height, const int pooled_width,  const int kernel_h, const int kernel_w, const int stride_h, const int stride_w, __global T* rand_idx, __global T* top_data){
    int index = get_global_id(0);
    int tmp = get_global_size(0);
    for(index; index < nthreads; index+=tmp){
    const int pw = index % pooled_width;
    const int ph = (index / pooled_width) % pooled_height;
    const int c = (index / pooled_width / pooled_height) % channels;
    const int n = index / pooled_width / pooled_height / channels;
    const int hstart = ph * stride_h;
    const int hend = min(hstart + kernel_h, height);
    const int wstart = pw * stride_w;
    const int wend = min(wstart + kernel_w, width);
    T cumsum = 0.;
    bottom_data = bottom_data + (n * channels + c) * height * width;
    // First pass: get sum
    for (int h = hstart; h < hend; ++h) {
      for (int w = wstart; w < wend; ++w) {
        cumsum += bottom_data[h * width + w];
      }
    }
    const float thres = rand_idx[index] * cumsum;
    // Second pass: get value, and set index.
    cumsum = 0;
    for (int h = hstart; h < hend; ++h) {
      for (int w = wstart; w < wend; ++w) {
        cumsum += bottom_data[h * width + w];
        if (cumsum >= thres) {
          rand_idx[index] = ((n * channels + c) * height + h) * width + w;
          top_data[index] = bottom_data[h * width + w];
          return;
        }
      }
    }
    }
}
template __attribute__((mangled_name(StoPoolForwardTrainfloat))) __kernel void StoPoolForwardTrain(const int nthreads, __global float* bottom_data, const int num, const int channels, const int height, const int width, const int pooled_height, const int pooled_width, const int kernel_h, const int kernel_w, const int stride_h, const int stride_w, __global float* idx_data, __global float* top_data);
template __attribute__((mangled_name(StoPoolForwardTrainDouble))) __kernel void StoPoolForwardTrain(const int nthreads, __global double* bottom_data, const int num, const int channels, const int height, const int width, const int pooled_height, const int pooled_width, const int kernel_h, const int kernel_w, const int stride_h, const int stride_w, __global double* idx_data, __global double* top_data);

template <class T>
__kernel void StoPoolForwardTest(const int count, __global T* bottom_data, const int clnum, const int channels, const int height, const int width, const int pooled_height, const int pooled_width,  const int kernel_h, const int kernel_w, const int stride_h, const int stride_w, __global T* top_data){
    int index = get_global_id(0);
    int tmp = get_global_size(0);
    for(index; index < count; index+=tmp){
    const int pw = index % pooled_width; 
    const int ph = (index / pooled_width) % pooled_height;
    const int c = (index / pooled_width / pooled_height) % channels;
    const int n = index / pooled_width / pooled_height / channels;
    const int hstart = ph * stride_h;
    const int hend = min(hstart + kernel_h, height);
    const int wstart = pw * stride_w;
    const int wend = min(wstart + kernel_w, width);
    // We set cumsum to be 0 to avoid divide-by-zero problems    T cumsum = FLT_MIN;
    T cumsum = FLT_MIN;
    T cumvalues = 0.;
    bottom_data =        bottom_data + (n * channels + c) * height * width;
    // First pass: get sum
    for (int h = hstart; h < hend; ++h) {
      for (int w = wstart; w < wend; ++w) {
        cumsum += bottom_data[h * width + w];
        cumvalues += bottom_data[h * width + w] * bottom_data[h * width + w];
      }
    }
    top_data[index] = cumvalues / cumsum;  }
}
template __attribute__((mangled_name(StoPoolForwardTestfloat))) __kernel void StoPoolForwardTest(const int nthreads, __global float* bottom_data, const int num, const int channels, const int height, const int width, const int pooled_height, const int pooled_width, const int kernel_h, const int kernel_w, const int stride_h, const int stride_w,__global float* top_data);
template __attribute__((mangled_name(StoPoolForwardTestdouble))) __kernel void StoPoolForwardTest(const int nthreads, __global double* bottom_data, const int num, const int channels, const int height, const int width, const int pooled_height, const int pooled_width, const int kernel_h, const int kernel_w, const int stride_h, const int stride_w, __global double* top_data);

template <class T>
__kernel void MaxPoolBackward(const int nthreads, __global T* top_diff,
    __global int* mask, __global T* top_mask, const int num,
    const int channels, const int height, const int width,
    const int pooled_height, const int pooled_width, const int kernel_h,
    const int kernel_w, const int stride_h, const int stride_w, const int pad_h,
    const int pad_w, __global T* const bottom_diff) {
     int index = get_global_id(0);
     int total = get_global_size(0);
     for(index; index < nthreads; index += total){
    // find out the local index
    // find out the local offset
    const int w = index % width;
    const int h = (index / width) % height;
    const int c = (index / width / height) % channels;
    const int n = index / width / height / channels;
    const int phstart =
         (h + pad_h < kernel_h) ? 0 : (h + pad_h - kernel_h) / stride_h + 1;
    const int phend = min((h + pad_h) / stride_h + 1, pooled_height);
    const int pwstart =
         (w + pad_w < kernel_w) ? 0 : (w + pad_w - kernel_w) / stride_w + 1;
    const int pwend = min((w + pad_w) / stride_w + 1, pooled_width);
    T gradient = 0;
    const int offset = (n * channels + c) * pooled_height * pooled_width;
    top_diff += offset;
    if (mask) {
      mask = mask + offset;
      for (int ph = phstart; ph < phend; ++ph) {
        for (int pw = pwstart; pw < pwend; ++pw) {
          if (mask[ph * pooled_width + pw] == h * width + w) {
            gradient += top_diff[ph * pooled_width + pw];
          }
        }
      }
    } else {
      top_mask = top_mask + offset;
      for (int ph = phstart; ph < phend; ++ph) {
        for (int pw = pwstart; pw < pwend; ++pw) {
          if (top_mask[ph * pooled_width + pw] == h * width + w) {
            gradient += top_diff[ph * pooled_width + pw];
          }
        }
      }
    }
    bottom_diff[index] = gradient;
  }
}
template __attribute__((mangled_name(MaxPoolBackwardfloat))) __kernel void MaxPoolBackward(const int nthreads, __global float* const top_diff, __global int* const mask, __global float* const top_mask, const int num, const int channels, const int height, const int width, const int pooled_height, const int pooled_width, const int kernel_h, const int kernel_w, const int stride_h, const int stride_w, const int pad_h, const int pad_w, __global float* bottom_diff);
template __attribute__((mangled_name(MaxPoolBackwarddouble))) __kernel void MaxPoolBackward(const int nthreads, __global double* top_diff, __global int* const mask, __global double* const top_mask, const int num, const int channels, const int height, const int width, const int pooled_height, const int pooled_width, const int kernel_h, const int kernel_w, const int stride_h, const int stride_w, const int pad_h, const int pad_w, __global double* bottom_diff);

template <class T>
__kernel void AvePoolBackward(const int nthreads, __global T* top_diff, const int num, const int channels, const int height, const int width, const int pooled_height, const int pooled_width, const int kernel_h, const int kernel_w, const int stride_h, const int stride_w, const int pad_h, const int pad_w, __global T* const bottom_diff){
     int index = get_global_id(0);
     int total = get_global_size(0);
     for(index; index < nthreads; index += total){
            int w = index % width + pad_w;
            int h = (index / width) % height + pad_h;
            int c = (index / width / height) % channels;
            int n = index / width / height / channels;
            const int phstart = (h < kernel_h) ? 0 : (h - kernel_h) / stride_h + 1;
            const int phend = min(h / stride_h + 1, pooled_height);
            const int pwstart = (w < kernel_w) ? 0 : (w - kernel_w) / stride_w + 1;
            const int pwend = min(w / stride_w + 1, pooled_width);
            T gradient = 0;
            top_diff += (n * channels + c) * pooled_height * pooled_width;
            for (int ph = phstart; ph < phend; ++ph) {
              for (int pw = pwstart; pw < pwend; ++pw) {
                // figure out the pooling size
                int hstart = ph * stride_h - pad_h;
                int wstart = pw * stride_w - pad_w;
                int hend = min(hstart + kernel_h, height + pad_h);
                int wend = min(wstart + kernel_w, width + pad_w);
                int pool_size = (hend - hstart) * (wend - wstart);
                gradient += top_diff[ph * pooled_width + pw] / pool_size;
              }
    }
    bottom_diff[index] = gradient;
   }
}

template __attribute__((mangled_name(AvePoolBackwardfloat))) __kernel void AvePoolBackward(const int nthreads, __global float* top_diff, const int num, const int channels, const int height, const int width, const int pooled_height, const int pooled_width, const int kernel_h, const int kernel_w, const int stride_h, const int stride_w, const int pad_h, const int pad_w, __global float* bottom_diff);
template __attribute__((mangled_name(AvePoolBackwarddouble))) __kernel void AvePoolBackward(const int nthreads, __global double* top_diff, const int num, const int channels, const int height, const int width, const int pooled_height, const int pooled_width, const int kernel_h, const int kernel_w, const int stride_h, const int stride_w, const int pad_h, const int pad_w, __global double* bottom_diff);

template <class Dtype>
void StoPoolBackward(const int nthreads,
    __global Dtype* rand_idx, __global Dtype* top_diff,
    const int num, const int channels, const int height,
    const int width, const int pooled_height, const int pooled_width,
    const int kernel_h, const int kernel_w, const int stride_h,
    const int stride_w, __global Dtype* bottom_diff) {
      int index = get_global_id(0);
      int total = get_global_size(0);
      for(index; index < nthreads; index += total){
            // find out the local index
            // find out the local offset
            const int w = index % width;
            const int h = (index / width) % height;
            const int c = (index / width / height) % channels;
            const int n = index / width / height / channels;
            const int phstart = (h < kernel_h) ? 0 : (h - kernel_h) / stride_h + 1;
            const int phend = min(h / stride_h + 1, pooled_height);
            const int pwstart = (w < kernel_w) ? 0 : (w - kernel_w) / stride_w + 1;
            const int pwend = min(w / stride_w + 1, pooled_width);
            Dtype gradient = 0;
            rand_idx =
                rand_idx + (n * channels + c) * pooled_height * pooled_width;
            top_diff =
                top_diff + (n * channels + c) * pooled_height * pooled_width;
            for (int ph = phstart; ph < phend; ++ph) {
              for (int pw = pwstart; pw < pwend; ++pw) {
                gradient += top_diff[ph * pooled_width + pw] *
                    (index == static_cast<int>(rand_idx[ph * pooled_width + pw]));
              }
            }
            bottom_diff[index] = gradient;

	  }
}
template __attribute__ ((mangled_name(StoPoolBackwardfloat))) __kernel  void StoPoolBackward<float>(const int nthreads,
    __global float* rand_idx, __global float* top_diff,
    const int num, const int channels, const int height,
    const int width, const int pooled_height, const int pooled_width,
    const int kernel_h, const int kernel_w, const int stride_h,
    const int stride_w, __global float* bottom_diff);
template __attribute__ ((mangled_name(StoPoolBackwarddouble))) __kernel void StoPoolBackward<double>(const int nthreads,
    __global double* rand_idx, __global double* top_diff,
    const int num, const int channels, const int height,
    const int width, const int pooled_height, const int pooled_width,
    const int kernel_h, const int kernel_w, const int stride_h,
    const int stride_w, __global double* bottom_diff);

template <class T>
__kernel void ReLUForward(const int count, __global T* in, __global T* out, T negative_slope){
	int index = get_global_id(0);
	if(index < count)
		out[index] = in[index] > 0? in[index]:in[index]*negative_slope;
}

//template __attribute__ ((mangled_name(ReLUForwardfloat))) __kernel void ReLUForward(const int count, __global float4* in, __global float4* out, float negative_slope);
template __attribute__ ((mangled_name(ReLUForwardfloat))) __kernel void ReLUForward(const int count, __global float* in, __global float* out, float negative_slope);
template __attribute__ ((mangled_name(ReLUForwarddouble))) __kernel void ReLUForward(const int count, __global double* in, __global double* out, double negative_slope);

template <class T>
__kernel void ReLUBackward(const int count, __global T* in_diff, __global T* in_data,__global T* out_diff,T negative_slope){
	int index = get_global_id(0);
        if(index < count)
		out_diff[index] = in_diff[index] * (in_data[index] > 0)+(in_data[index] <= 0) * negative_slope;
}

template __attribute__ ((mangled_name(ReLUBackwardfloat))) __kernel void ReLUBackward(const int count, __global float* in_diff, __global float* in_data, __global float* out_diff, float negative_slope);
template __attribute__ ((mangled_name(ReLUBackwarddouble))) __kernel void ReLUBackward(const int count, __global double* in_diff, __global double* in_data, __global double* out_diff, double negative_slope);

template <class T>
__kernel void get_max(const int num, const int dim, __global T* data, __global T* out){
     int index = get_global_id(0);
     if (index < num) {
	T maxval = -FLT_MAX;
        for (int i = 0; i <  dim; i++)
	maxval = max( data[index*dim + i], maxval );
        out[index] = maxval;
      }
}

template __attribute__ ((mangled_name(get_max_float))) __kernel void get_max(const int num, const int dim, __global float* data, __global float* out);
template __attribute__ ((mangled_name(get_max_double))) __kernel void get_max(const int num, const int dim, __global double* data, __global double* out);

template <class T>
__kernel void exp (const int num, __global T* data, __global T* out){
        int index = get_global_id(0);
        if (index < num) 
        out[index] = exp(data[index]);
}

template __attribute__ ((mangled_name(exp_float))) __kernel void exp (const int num, __global float* data, __global float* out);
template __attribute__ ((mangled_name(exp_double))) __kernel void exp (const int num, __global double* data, __global double* out);

template <class T>
__kernel void softmax_div (const int num, const int dim, __global T* scale, __global T* data){
        //printf("softmax_div\n");
        int index = get_global_id(0);
        int total = get_global_size(0);
        for(index; index < num*dim; index +=  total){
        int n = index / dim;
        data[index] /= scale[n];
        }
}

template __attribute__ ((mangled_name(softmax_div_float))) __kernel void softmax_div (const int num, const int dim, __global float* scale, __global float* data);
template __attribute__ ((mangled_name(softmax_div_double))) __kernel void softmax_div (const int num, const int dim, __global double* scale, __global double* data);

template <class T>
__kernel void softmax(__global T* prob_data, __global T* loss, __global T* label, int num, int dim, __local T* resultScratch){
    
    int gid = get_global_id(0);
    int size = get_global_size(0);
    
    resultScratch[gid] = 0.0;
    for(int i = gid; i < num; i += size){
    	resultScratch[gid] += -log(prob_data[i * dim + static_cast<int>(label[i])]);
    }
    barrier(CLK_LOCAL_MEM_FENCE);
    
    if(gid < 128)
    	resultScratch[gid] += resultScratch[gid + 128];
    barrier(CLK_LOCAL_MEM_FENCE);
    if(gid < 64)
    	resultScratch[gid] += resultScratch[gid + 64];
    if(gid < 32)
    	resultScratch[gid] += resultScratch[gid + 32];
    if(gid < 16)
    	resultScratch[gid] += resultScratch[gid + 16];
    if(gid < 8)
    	resultScratch[gid] += resultScratch[gid + 8];
    if(gid < 4)
    	resultScratch[gid] += resultScratch[gid + 4];
    if(gid < 2)
    	resultScratch[gid] += resultScratch[gid + 2];
    if(gid < 1){
    	resultScratch[gid] += resultScratch[gid + 1];
    	loss[0] = resultScratch[gid];
    }

}

template __attribute__ ((mangled_name(softmax_float))) __kernel void softmax (__global float* prob_data, __global float* loss, __global float* label, int num, int dim, __local float* resultScratch);
template __attribute__ ((mangled_name(softmax_double))) __kernel void softmax (__global double* prob_data, __global double* loss, __global double* label, int num, int dim, __local double* resultScratch);

template <class T>
__kernel void kernel_channel_max(const int num, const int channels,
    const int spatial_dim, __global const T* data, __global T* out) {
    int index = get_global_id(0);
    if(index < num * spatial_dim) {
    int n = index / spatial_dim;
    int s = index % spatial_dim;
    T maxval = -FLT_MAX;
    for (int c = 0; c < channels; ++c) {
      maxval = max(data[(n * channels + c) * spatial_dim + s], maxval);
    }
    out[index] = maxval;
  }
}

template __attribute__ ((mangled_name(kernel_channel_max_float))) __kernel void kernel_channel_max(const int num, const int channels,
    const int spatial_dim, __global const float* data, __global float* out);
template __attribute__ ((mangled_name(kernel_channel_max_double))) __kernel void kernel_channel_max(const int num, const int channels,
    const int spatial_dim, __global const double* data, __global  double* out);

template <class T>
__kernel void kernel_channel_subtract(const int count,
    const int num, const int channels,
    const int spatial_dim, __global const T* channel_max, __global T* data) {
    int index = get_global_id(0);
    if(index < count) {
    int n = index / channels / spatial_dim;
    int s = index % spatial_dim;
    data[index] -= channel_max[n * spatial_dim + s];
  }
}

template __attribute__ ((mangled_name(kernel_channel_subtract_float))) __kernel void kernel_channel_subtract(const int count, const int num, const int channels, const int spatial_dim, __global const float* channel_max, __global float* data);
template __attribute__ ((mangled_name(kernel_channel_subtract_double))) __kernel void kernel_channel_subtract(const int count, const int num, const int channels, const int spatial_dim, __global const double* channel_max, __global double* data);

template <class T>
__kernel void kernel_exp(const int count, __global const T* data, __global T* out) {
 int index = get_global_id(0);
   if(index < count) {
    out[index] = exp(data[index]);
  }
}

template __attribute__ ((mangled_name(kernel_exp_float))) __kernel void kernel_exp(const int count, __global const float* data, __global float* out);
template __attribute__ ((mangled_name(kernel_exp_double))) __kernel void kernel_exp(const int count, __global const double* data, __global double* out);

template <class T>
__kernel void kernel_channel_sum(const int num, const int channels,
    const int spatial_dim, __global const T* data, __global T* channel_sum) {
  int index = get_global_id(0);
   if(index < num * spatial_dim) {
    int n = index / spatial_dim;
    int s = index % spatial_dim;
    T sum = 0;
    for (int c = 0; c < channels; ++c) {
      sum += data[(n * channels + c) * spatial_dim + s];
    }
    channel_sum[index] = sum;
  }
}

template __attribute__ ((mangled_name(kernel_channel_sum_float))) __kernel void kernel_channel_sum(const int num, const int channels,
    const int spatial_dim, __global const float* data, __global float* channel_sum);
template __attribute__ ((mangled_name(kernel_channel_sum_double))) __kernel void kernel_channel_sum(const int num, const int channels,
    const int spatial_dim, __global const double* data, __global double* channel_sum);

template <class T>
__kernel void kernel_channel_div(const int count,
    const int num, const int channels,
    const int spatial_dim, __global const T* channel_sum, __global T* data) {
    int index = get_global_id(0);
   if(index < count) {
    int n = index / channels / spatial_dim;
    int s = index % spatial_dim;
    data[index] /= channel_sum[n * spatial_dim + s];
  }
}

template __attribute__ ((mangled_name(kernel_channel_div_float))) __kernel void kernel_channel_div(const int count,
    const int num, const int channels,
    const int spatial_dim, __global const float* channel_sum, __global float* data);
template __attribute__ ((mangled_name(kernel_channel_div_double))) __kernel void kernel_channel_div(const int count,
    const int num, const int channels,
    const int spatial_dim, __global const double* channel_sum, __global double* data);

template <class T>
__kernel void kernel_channel_dot(const int num, const int channels,
    const int spatial_dim, __global const T* data_1, __global const T* data_2,
    __global T* channel_dot) {
    int index = get_global_id(0);
    if(index < num * spatial_dim) {
        int n = index / spatial_dim;
        int s = index % spatial_dim;
        T dot = 0;
        for (int c = 0; c < channels; ++c) {
            dot += (data_1[(n * channels + c) * spatial_dim + s]
                 * data_2[(n * channels + c) * spatial_dim + s]);
        }
        channel_dot[index] = dot;
    }
}

template __attribute__ ((mangled_name(kernel_channel_dot_float))) __kernel void kernel_channel_dot(const int num, const int channels,
    const int spatial_dim, __global const float* data_1, __global const float* data_2,
    __global float* channel_dot);
template __attribute__ ((mangled_name(kernel_channel_dot_double))) __kernel void kernel_channel_dot(const int num, const int channels,
    const int spatial_dim, __global const double* data_1, __global const double* data_2,
    __global double* channel_dot);


template <class T>
__kernel void SoftmaxLossForwardGPU(const int nthreads,
          __global T* prob_data, __global T* label,__global T* loss,
          int num, int dim, int spatial_dim,
          bool has_ignore_label_, int ignore_label_,
          __global T* counts) {
    int index = get_global_id(0);
    if(index < nthreads) {
        const int n = index / spatial_dim;
        const int s = index % spatial_dim;
        const int label_value = static_cast<int>(label[n * spatial_dim + s]);
        if (has_ignore_label_ && label_value == ignore_label_) {
           loss[index] = 0;
           counts[index] = 0;
        } else {
           loss[index] = -log(max(prob_data[n * dim + label_value * spatial_dim + s],
                      T(FLT_MIN)));
        counts[index] = 1;
    }
  }
}

template __attribute__ ((mangled_name(softmax_loss_fp_float))) __kernel void SoftmaxLossForwardGPU(int nthreads,
          __global float* prob_data, __global float* label,__global float* loss,
          int num, int dim, int spatial_dim,
          bool has_ignore_label_, int ignore_label_,
          __global float* counts);
template __attribute__ ((mangled_name(softmax_loss_fp_double))) __kernel void SoftmaxLossForwardGPU(int nthreads,
          __global double* prob_data, __global double* label,__global double* loss,
          int num, int dim, int spatial_dim,
          bool has_ignore_label_, int ignore_label_,
          __global double* counts);

template <class T>
__kernel void SoftmaxLossBackwardGPU(int nthreads, __global T* top,
          __global T* label,__global T* bottom_diff, int num, int dim,
          int spatial_dim, bool has_ignore_label_,
          int ignore_label_, T* counts) {
    const int channels = dim / spatial_dim;
   int index  = get_global_id(0);
   if(index <  nthreads) {
       const int n = index / spatial_dim;
       const int s = index % spatial_dim;
       const int label_value = static_cast<int>(label[n * spatial_dim + s]);

      if (has_ignore_label_ && label_value == ignore_label_) {
          for (int c = 0; c < channels; ++c) {
              bottom_diff[n * dim + c * spatial_dim + s] = 0;
          }
          counts[index] = 0;
    } else {
      bottom_diff[n * dim + label_value * spatial_dim + s] -= 1;
      counts[index] = 1;
    }
  }
}


template __attribute__ ((mangled_name(softmax_loss_bp_float))) __kernel void SoftmaxLossBackwardGPU(int nthreads, __global float* top,
          __global float* label,__global float* bottom_diff, int num, int dim,
          int spatial_dim, bool has_ignore_label_,
          int ignore_label_, float* counts);

template __attribute__ ((mangled_name(softmax_loss_bp_double)))  __kernel void SoftmaxLossBackwardGPU(int nthreads, __global double* top,
          __global double* label,__global double* bottom_diff, int num, int dim,
          int spatial_dim, bool has_ignore_label_,
          int ignore_label_, double* counts);


template <class T>
__kernel void diff (const int num, const int dim, __global T* data, __global T* label){
        int index = get_global_id(0);
        int total = get_global_size(0);
        int offset;
	for(index; index < num; index +=  total){
  	offset = (int) label[index];
        data[index * dim + offset] -= 1;
        }
}

template __attribute__ ((mangled_name(diff_float))) __kernel void diff (const int num, const int dim, __global float* data, __global float* label);
template __attribute__ ((mangled_name(diff_double))) __kernel void diff (const int num, const int dim, __global double* data, __global double* label);

template <class T>
__kernel void scal (const int num, const T alpha, __global T* data){
        int index = get_global_id(0);
        int total = get_global_size(0);
        for(index; index < num; index +=  total){
        data[index] = data[index] * alpha;
        }
}

template __attribute__ ((mangled_name(scal_float))) __kernel void scal (const int num, const float alpha,  __global float* data);
template __attribute__ ((mangled_name(scal_double))) __kernel void scal (const int num, const double alpha,  __global double* data);

template <class T>
__kernel void div (const int n, __global const T* a, __global const T* b, __global T* y){
	int index = get_global_id(0);
        if (index < n)
        y[index] = a[index] / b[index];
}

template __attribute__ ((mangled_name(div_float))) __kernel void div (const int n, __global const float* a, __global const float* b, __global float* y);
//template __attribute__ ((mangled_name(div_double))) __kernel void div (const int n, __global const double* a, __global const double* b, __global double* y);

template <class T>
__kernel void add_scalar (const int n, const T alpha, __global T* y){
        int index = get_global_id(0);
        if (index < n)
        y[index] += alpha;
}

template __attribute__ ((mangled_name(add_scalar_float))) __kernel void add_scalar (const int n, const float alpha, __global float* y);
template __attribute__ ((mangled_name(add_scalar_double))) __kernel void add_scalar (const int n, const double alpha, __global double* y);

template <typename Dtype>
__kernel void caffe_gpu_add(const int n, const Dtype* in1, const Dtype* in2, Dtype* y){
        int index = get_global_id(0);
        if (index < n)
        y[index] = in1[index] + in2[index] ;
}
template __attribute__ ((mangled_name(caffe_gpu_add_float))) __kernel void caffe_gpu_add(const int n, const float* in1, const float* in2, float* y);
template __attribute__ ((mangled_name(caffe_gpu_add_double))) __kernel void caffe_gpu_add(const int n, const double* in1, const double* in2, double* y);

template <class T>
__kernel void element_mul (const int n, __global const T* a, __global const T* b, __global T* y){
        int index = get_global_id(0);
       if (index < n)
        y[index] = a[index] * b[index];
}

template __attribute__ ((mangled_name(element_mul_float))) __kernel void element_mul (const int n, __global const float* a, __global const float* b, __global float* y);
template __attribute__ ((mangled_name(element_mul_double))) __kernel void element_mul (const int n,__global const double* a, __global const double* b, __global double* y);


template <class T>
__kernel void powx (const int n, __global const T* a, const T alpha, __global T* y){
        int index = get_global_id(0);
        if (index < n)
//           y[index] = a[index] + alpha;
           y[index] = pow(a[index], alpha);
}

template __attribute__ ((mangled_name(powx_float))) __kernel void powx (const int n, __global const float* a, const float alpha, __global float* y); 
template __attribute__ ((mangled_name(powx_double))) __kernel void powx (const int n, __global const double* a, const double alpha, __global double* y); 

template <class T>
__kernel void DropoutForward(const int n, __global T *in, __global const int* mask, const T scale, __global T *out){
    int index = get_global_id(0);
    if (index < n)
        out[index] = in[index] * scale * mask[index];
}
template __attribute__((mangled_name(DropoutForwardfloat))) __kernel void DropoutForward(const int n, __global float* in,  __global const int* mask, const float scale, __global float* out); 
template __attribute__((mangled_name(DropoutForwarddouble))) __kernel void DropoutForward(const int n, __global double* in, __global const int* mask, const double scale, __global double* out);


template <class T>
__kernel void DropoutBackward(const int n, __global T *in_diff, __global const int *mask, const int unsigned threshold, const T scale, __global T *out_diff){
    int index = get_global_id(0);
    if (index < n)
        out_diff[index] = in_diff[index] * scale * mask[index];
}
template __attribute__((mangled_name(DropoutBackwardfloat))) __kernel void DropoutBackward(const int n, __global float* in_diff,  __global const int* mask, const unsigned int threshold, const float scale, __global float* out_diff); 
template __attribute__((mangled_name(DropoutBackwarddouble))) __kernel void DropoutBackward(const int n, __global double* in_diff, __global const int* mask, const unsigned int threshold, const double scale, __global double* out_diff);

template <class T>
__kernel void LRNFillScale(const int nthreads, __global T* in, const int num, const int channels, const int height, const int width, const int size, const T alpha_over_size, const T k,  __global T* scale) {
  int index = get_global_id(0);
  int tmp = get_global_size(0);
  for(index; index < nthreads; index += tmp) {
    // find out the local offset
    const int w = index % width;
    const int h = (index / width) % height;
    const int n = index / width / height;
    const int offset = (n * channels * height + h) * width + w;
    const int step = height * width;
    in = in + offset;
    scale = scale + offset;
    int head = 0;
    const int pre_pad = (size - 1) / 2;
    const int post_pad = size - pre_pad - 1;
    T accum_scale = 0;
    // fill the scale at [n, :, h, w]
    // accumulate values
    while (head < post_pad && head < channels) {
      accum_scale += in[head * step] * in[head * step];
      ++head;
    }
    // both add and subtract
    while (head < channels) {
      accum_scale += in[head * step] * in[head * step];
      if (head - size >= 0) {
        accum_scale -= in[(head - size) * step]
                       * in[(head - size) * step];
      }
      scale[(head - post_pad) * step] = k + accum_scale * alpha_over_size;
      ++head;
    }
    // subtract only
    while (head < channels + post_pad) {
      if (head - size >= 0) {
        accum_scale -= in[(head - size) * step]
                       * in[(head - size) * step];
      }
      scale[(head - post_pad) * step] = k + accum_scale * alpha_over_size;
      ++head;
    }
  }
}

template __attribute__((mangled_name(LRNFillScalefloat))) __kernel void LRNFillScale (const int nthreads, __global float* in, const int num, const int channels, const int height, const int width, const int size, const float alpha_over_size, const float k,  __global float* scale);
template __attribute__((mangled_name(LRNFillScaledouble))) __kernel void LRNFillScale (const int nthreads, __global double* in, const int num, const int channels, const int height, const int width, const int size, const double alpha_over_size, const double k, __global double* scale);

template <class T>
__kernel void LRNComputeOutput(const int nthreads, __global T* in, __global T* scale, const T negative_beta, __global T* out) {
  int index = get_global_id(0);
  int tmp = get_global_size(0);
  for(index; index < nthreads; index += tmp) 
    out[index] = in[index] * pow(scale[index], negative_beta);
}
template __attribute__((mangled_name(LRNComputeOutputfloat))) __kernel void LRNComputeOutput(const int nthreads, __global float* in, __global float* scale, const float negative_beta, __global float* out);
template __attribute__((mangled_name(LRNComputeOutputdouble))) __kernel void LRNComputeOutput(const int nthreads, __global double* in, __global double* scale, const double negative_beta, __global double* out);

template <class T>
__kernel void LRNComputeDiff(const int nthreads, __global T* bottom_data, __global T* top_data, __global T* scale, __global T* top_diff, const int num, const int channels, const int height, const int width, const int size, const T negative_beta, const T cache_ratio, __global T* bottom_diff) {
  int index = get_global_id(0);
  int tmp = get_global_size(0);
  for(index; index < nthreads; index += tmp) {
    const int w = index % width;
    const int h = (index / width) % height;
    const int n = index / width / height;
    const int offset = (n * channels * height + h) * width + w;
    const int step = height * width;
    bottom_data += offset;
    top_data += offset;
    scale += offset;
    top_diff += offset;
    bottom_diff += offset;
    int head = 0;
    const int pre_pad = size - (size + 1) / 2;
    const int post_pad = size - pre_pad - 1;
    T accum_ratio = 0;
    // accumulate values
    while (head < post_pad && head < channels) {
      accum_ratio += top_diff[head * step] * top_data[head * step] /
          scale[head * step];
      ++head;
    }
    // both add and subtract
    while (head < channels) {
      accum_ratio += top_diff[head * step] * top_data[head * step] /
          scale[head * step];
      if (head - size >= 0) {
        accum_ratio -= top_diff[(head - size) * step] *
            top_data[(head - size) * step] / scale[(head - size) * step];
      }
      bottom_diff[(head - post_pad) * step] =
          top_diff[(head - post_pad) * step]
            * pow(scale[(head - post_pad) * step], negative_beta)
          - cache_ratio * bottom_data[(head - post_pad) * step] * accum_ratio;
      ++head;
    }
    // subtract only
    while (head < channels + post_pad) {
      if (head - size >= 0) {
        accum_ratio -= top_diff[(head - size) * step] *
            top_data[(head - size) * step] / scale[(head - size) * step];
      }
      bottom_diff[(head - post_pad) * step] =
          top_diff[(head - post_pad) * step]
            * pow(scale[(head - post_pad) * step], negative_beta)
          - cache_ratio * bottom_data[(head - post_pad) * step] * accum_ratio;
      ++head;
    }
}
}

template __attribute__((mangled_name(LRNComputeDifffloat))) __kernel void LRNComputeDiff(const int nthreads, __global float* bottom_data, __global float* top_data, __global float* scale, __global float* top_diff, const int num, const int channels, const int height, const int width, const int size, const float negative_beta, const float cache_ratio, __global float* bottom_diff);
template __attribute__((mangled_name(LRNComputeDiffdouble))) __kernel void LRNComputeDiff(const int nthreads, __global double* bottom_data, __global double* top_data, __global double* scale, __global double* top_diff, const int num, const int channels, const int height, const int width, const int size, const double negative_beta, const double cache_ratio, __global double* bottom_diff);

template <class T>
__kernel void transpose(__global const T *src, __global T* dst, int width, int height, int optnum){
     int gidx = get_global_id(0);
     int gidy = get_global_id(1);
     int gidyy = gidy;
     int index = gidy / height;
     int offset = index * width * height;
     gidy = gidy % height;
     if( gidx < width && gidyy < height * optnum )
         dst[offset + height * gidx + gidy] = src[offset + width * gidy + gidx];
}
template __attribute__((mangled_name(transposefloat))) __kernel void transpose(__global const float* src, __global float* dst, const int width, const int height, int optnum); 
template __attribute__((mangled_name(transposedouble))) __kernel void transpose(__global const double* src, __global double* dst, const int width, const int heighti, int optnum);

template <class T>
__kernel void transform(__global const T *src, __global T* dst, int top_offset, int width, int height, int optnum){
     int gidx = get_global_id(0);
     int index;
     index = (optnum==1) ? 0: gidx % optnum;
     dst = dst + top_offset; // now we point at (*top)[n]
     int offset = gidx / optnum;
     int i = 0;
     for(i = 0 ; i < width; i++)
         dst[(index * height + offset)* width + i] = src[gidx * width + i];
}
template __attribute__((mangled_name(transformfloat))) __kernel void transform(__global const float* src, __global float* dst, int top_offset, const int width, const int height, const int optnum); 
template __attribute__((mangled_name(transformdouble))) __kernel void transform(__global const double* src, __global double* dst, int top_offset, const int width, const int height, const int optnum); 