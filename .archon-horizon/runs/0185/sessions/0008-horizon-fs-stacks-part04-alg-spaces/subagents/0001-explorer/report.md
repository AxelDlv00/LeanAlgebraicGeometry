Inspected Part04 without edits. `lake env lean StacksPart04Lib.lean` passes cleanly.

Current Lean library is a sorry-free categorical kernel:

- `Representability.lean`: `morphismScheme_representable`, composition/base-change/isomorphism stability, relative morphism-property APIs, diagonal criterion.
- `RepresentabilityAdvanced.lean`: pairwise fibre-product diagonal criterion and relative-property constructors.
- `Products.lean`: product pullback lemmas and `representableTransformation_prod`.
- `RelationGroupoid.lean`: thin groupoid from `Setoid`, `homOfRel`/`relOfHom`, `nonempty_hom_iff`, inverse laws.
- `Descent.lean` and `DescentFunctoriality.lean`: `DescentSection`, extensionality, component determination, groupoid inverse compatibility, pullback/map functoriality.
- `Groupoids.lean`/`GroupoidFunctoriality.lean`: generic groupoid facts.

Concrete next proof frontier should remain categorical:

1. Add descent-section equalizer/fixed-point APIs for `RelationCategory`, especially characterize a section by one chosen value and relation transport.
2. Add elementary quotient shadows for thin relation groupoids and functors preserving relations.
3. Add finite/coproduct representability lemmas using existing `prod.map` and base-change APIs.

The graph’s highest frontier labels are relative representability, base-change/composition, diagonal, and covering/quotient results. The first three already have corresponding Lean implementations under different names and should be graph-linked rather than duplicated. Geometric nodes such as “Space presentation”, “Covering quotient”, and “Divide subgroupoid” require absent scheme/algebraic-space quotient infrastructure; do not attempt global quotient instances. Part07 has nearly identical categorical APIs plus `FiberedSetoids`/`FiberedGroupoids`, useful as reference only.

I recorded this in the Part04 task inbox and sent a conversation note to the active Part04 run.
