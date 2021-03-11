function Vector(x, y) {
    this.x = x || 0
    this.y = y || 0
}

Vector.prototype = {
    "negative": function () {
        this.x = -this.x
        this.y = -this.y
        return this
    },
    "add": function (v) {
        if (v instanceof Vector) {
            this.x += v.x
            this.y += v.y
        } else {
            this.x += v
            this.y += v
        }
        return this
    },
    "subtract": function (v) {
        if (v instanceof Vector) {
            this.x -= v.x
            this.y -= v.y
        } else {
            this.x -= v
            this.y -= v
        }
        return this
    },
    "multiply": function (v) {
        if (v instanceof Vector) {
            this.x *= v.x
            this.y *= v.y
        } else {
            this.x *= v
            this.y *= v
        }
        return this
    },
    "divide": function (v) {
        if (v instanceof Vector) {
            if (v.x != 0)
                this.x /= v.x
            if (v.y != 0)
                this.y /= v.y
        } else {
            if (v != 0) {
                this.x /= v
                this.y /= v
            }
        }
        return this
    },
    "equals": function (v) {
        return this.x == v.x && this.y == v.y
    },
    "dot": function (v) {
        return this.x * v.x + this.y * v.y
    },
    "cross": function (v) {
        return this.x * v.y - this.y * v.x
    },
    "length": function () {
        return Math.sqrt(this.dot(this))
    },
    "normalize": function () {
        return this.divide(this.length())
    },
    "min": function () {
        return Math.min(this.x, this.y)
    },
    "max": function () {
        return Math.max(this.x, this.y)
    },
    "toAngles": function () {
        return -Math.atan2(-this.y, this.x)
    },
    "angleTo": function (a) {
        return Math.acos(this.dot(a) / (this.length() * a.length()))
    },
    "toArray": function (n) {
        return [this.x, this.y].slice(0, n || 2)
    },
    "clone": function () {
        return new Vector(this.x, this.y)
    },
    "set": function (x, y) {
        this.x = x
        this.y = y
        return this
    }
}

function calculateCoverage(height, angle_nadir, beta, a, b, latitude_metr) {
    var longitude_metr_b = Math.cos(b.latitude) * latitude_metr
    var longitude_metr_a = Math.cos(a.latitude) * latitude_metr

    var wigth_1 = (Math.tan(parseInt(angle_nadir) * Math.PI / 180) * (parseInt(height)))
    var wigth_2 = (Math.tan((parseInt(angle_nadir)+parseInt(angle_nadir)) * Math.PI / 180) * (parseInt(height)))

    var vec_1 = new Vector((b.longitude - a.longitude), (b.latitude - a.latitude))
    console.log(vec_1.x,vec_1.y)
    vec_1 = vec_1.set(-vec_1.y, vec_1.x)
    console.log(vec_1.x,vec_1.y)
    vec_1 = vec_1.normalize()
    console.log(vec_1.x,vec_1.y)
    var vec_2 = vec_1.clone()
    vec_1 = vec_1.multiply(wigth_1)
    vec_2 = vec_2.multiply(wigth_2)

    var x1 = vec_1.x / longitude_metr_a + a.longitude
    var y1 = vec_1.y / latitude_metr + a.latitude

    var x2 = vec_1.x / longitude_metr_b + b.longitude
    var y2 = vec_1.y / latitude_metr + b.latitude

    var x3 = vec_2.x / longitude_metr_a + a.longitude
    var y3 = vec_2.y / latitude_metr + a.latitude

    var x4 = vec_2.x / longitude_metr_b + b.longitude
    var y4 = vec_2.y / latitude_metr + b.latitude

    return [y1, x1, y2, x2, y3, x3, y4, x4]
}
