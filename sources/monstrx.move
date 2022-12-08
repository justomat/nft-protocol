module nft_protocol::monstrx {
    use std::vector;

    use sui::tx_context::{Self, TxContext};

    use nft_protocol::collection::{MintAuthority};
    use nft_protocol::fixed_price::{Self, FixedPriceMarket};
    use nft_protocol::std_collection;
    use nft_protocol::unique_nft;
    use nft_protocol::slingshot::Slingshot;

    struct MONSTRX has drop {}

    fun init(witness: MONSTRX, ctx: &mut TxContext) {
        let tags: vector<vector<u8>> = vector::empty();
        vector::push_back(&mut tags, b"Art");

        let collection_id = std_collection::mint<MONSTRX>(
            b"Monstrx",
            b"A Unique NFT collection of Monstrx on Sui",
            b"MSRX", // symbol
            100, // max_supply
            @0x5283b785eb906160a073748c517a1f556bb6e8e0, // Royalty receiver
            tags, // tags
            100, // royalty_fee_bps
            true, // is_mutable
            b"Some extra data",
            tx_context::sender(ctx), // mint authority
            ctx,
        );

        let whitelist = vector::empty();
        vector::push_back(&mut whitelist, false);

        let prices = vector::empty();
        vector::push_back(&mut prices, 1000);

        fixed_price::create_market(
            witness,
            tx_context::sender(ctx), // admin
            collection_id,
            @0x5283b785eb906160a073748c517a1f556bb6e8e0,
            true, // is_embedded
            whitelist, prices,
            ctx,
        );
    }

    public entry fun mint_nft(
        name: vector<u8>,
        description: vector<u8>,
        url: vector<u8>,
        attribute_keys: vector<vector<u8>>,
        attribute_values: vector<vector<u8>>,
        mint_authority: &mut MintAuthority<MONSTRX>,
        sale_index: u64,
        launchpad: &mut Slingshot<MONSTRX, FixedPriceMarket>,
        ctx: &mut TxContext,
    ) {
        unique_nft::mint_regulated_nft(
            name,
            description,
            url,
            attribute_keys,
            attribute_values,
            mint_authority,
            sale_index,
            launchpad,
            ctx,
        );
    }
}
