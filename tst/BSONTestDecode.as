/**
 */
package
{
    import flash.utils.ByteArray;
    import flash.utils.Endian;

    import org.flexunit.Assert;

    import org.serialization.bson.BSON;

    [RunWith("org.flexunit.runners.Parameterized")]
    public class BSONTestDecode
    {
        /**
         * Create empty ByteArray and initalize it with encoded string data
         * @param encoded
         * @return
         */
        private static function createBytes( encoded:String ):ByteArray
        {
            const bytes:ByteArray = new ByteArray();
            bytes.endian = Endian.LITTLE_ENDIAN ;
            bytes.writeUTF ( encoded );
            return bytes ;
        }

        /**
         * Assert two objects are equal
         * @param text
         * @param a
         * @param b
         */
        public static function assertSame( text:String, a:Object, b:Object ):void
        {
            const bytesA:ByteArray = new ByteArray();
            bytesA.writeObject( a );
            bytesA.position = 0 ;

            const bytesB:ByteArray = new ByteArray();
            bytesB.writeObject( b );
            bytesB.position = 0 ;

            if ( bytesA.toString() != bytesB.toString() )
                Assert.fail( text + ' test failed' );
        }

        [Test(dataProvider="pairsList")]
        public function testPairs( description:String, encoded:String, object:Object ):void
        {
            const document:Object = BSON.decode( createBytes( encoded ) );

            assertSame( description, object, document );
        }

        public static function pairsList():Array
        {
            return [
                [
                    "Empty object",
                    '\x05\x00\x00\x00\x00',
                    {}
                ],
                [
                    "String data",
                    "\x16\x00\x00\x00\x02hello\x00\x06\x00\x00\x00world\x00\x00",
                    { hello:"world" }
                ]
            ];
        }
    }
}
