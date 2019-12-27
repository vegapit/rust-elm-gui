use statrs::distribution::{Normal, Univariate};

pub enum CallPut {
    Call,
    Put
}

pub struct Black76 {
    cp: CallPut,
    s: f64,
    k: f64,
    v: f64,
    t: f64,
    r: f64
}

impl Black76 {

    pub fn new(callput: CallPut, underlying: f64, strike: f64, timetomaturity: f64, volatility: f64, riskfreerate: f64) -> Black76 {
        Black76{cp: callput, s: underlying, k: strike, t: timetomaturity, v: volatility, r: riskfreerate}
    }

    fn d1(&self) -> f64 {
        ((self.s/self.k).ln() + 0.5 * self.v.powf(2.0) * self.t) / (self.v * self.t.powf(0.5))
    }

    fn d2(&self) -> f64 {
        self.d1() - self.v * self.t.powf(0.5)
    }

    pub fn price(&self) -> f64 {
        let stdnorm = Normal::new(0.0, 1.0).unwrap();
        match self.cp {
            CallPut::Call => (-self.r * self.t).exp() * ( self.s * stdnorm.cdf(self.d1()) - self.k * stdnorm.cdf(self.d2()) ),
            CallPut::Put => (-self.r * self.t).exp() * ( self.k * stdnorm.cdf(-self.d2()) - self.s * stdnorm.cdf(-self.d1()) )
        }
    }

    pub fn delta(&self) -> f64 {
        let stdnorm = Normal::new(0.0, 1.0).unwrap();
        match self.cp {
            CallPut::Call =>  (-self.r*self.t).exp() * stdnorm.cdf(self.d1()),
            CallPut::Put => -(-self.r*self.t).exp() * stdnorm.cdf(-self.d1())
        }
    }
}