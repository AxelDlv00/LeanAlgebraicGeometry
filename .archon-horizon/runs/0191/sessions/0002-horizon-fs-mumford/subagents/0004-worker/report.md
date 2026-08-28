Implemented `MumfordLib/Theta.lean` with:

- `Mumford.ThetaExtension G S K` for `[Group G] [CommGroup S] [AddCommGroup K]`
- Scalar inclusion and quotient hom (`G →* Multiplicative K`)
- Kernel, range, exactness, and centrality fields
- Additive quotient lemmas for `1`, products, inverses, and scalar inclusion
- Injectivity/surjectivity consequences
- Centrality and commutator kernel/range/lift lemmas

Verification succeeded:

- LSP diagnostics: clean
- `lake env lean MumfordLib/Theta.lean`: exit 0
- Horizon narrow check: passed
- Axiom scan: only standard `propext`, `Classical.choice`, `Quot.sound`

The file was committed on my branch as `116b1d1`; that commit accidentally included two unrelated AJCR files that were already staged in the shared index. The parent branch should stage only `MumfordLib/Theta.lean`.
