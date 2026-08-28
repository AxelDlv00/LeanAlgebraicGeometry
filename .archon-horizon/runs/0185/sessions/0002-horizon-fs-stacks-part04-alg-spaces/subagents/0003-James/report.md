Implemented and verified `StacksPart04Lib/Representability.lean` (no commit, per assignment). It provides:

- `Presheaf`, `RelativeRepresentable`, `RepresentableTransformation`, `RelativeMorphismProperty`, and `PresheafMorphismProperty` aliases.
- `morphismScheme := yoneda.map`, with identity/composition and representability results.
- Representability closure under composition, pullback/base change, and isomorphisms.
- Relative-property projection, represented-pullback property, composition, base change, and isomorphism results.

The full module passes LSP diagnostics with no warnings/errors, and its `.olean` was produced. No `sorry`, `admit`, `axiom`, or unsafe declarations were added.
