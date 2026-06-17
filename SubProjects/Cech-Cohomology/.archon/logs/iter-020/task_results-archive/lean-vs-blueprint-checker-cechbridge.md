# Lean ↔ Blueprint Check Report

## Slug
cechbridge

## Iteration
019

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/CechBridge.lean`
- Blueprint: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`

---

## Per-declaration

The consolidated chapter covers six `.lean` files; per the directive, only blocks whose
`\lean{...}` targets live in `CechBridge.lean` are audited here.

### `\lean{AlgebraicGeometry.cechComplex_hom_identification}` (chapter: `lem:cech_complex_hom_identification`)

- **Lean target exists**: yes — line 241 of `CechBridge.lean`
- **Signature matches**: yes
  - Blueprint (lines 1058–1071) states: "an isomorphism of cochain complexes of abelian groups
    `Hom_{O_X}(K(U)_•, F) = Č•(U, F)`, natural in `F ∈ PMod(O_X)`."
  - Lean type: `homCechComplex 𝒰 F ≅ sectionCechComplex (coverOpen 𝒰) F`
    — an `≅` in `CochainComplex Ab.{u} ℕ`, which is an isomorphism of cochain complexes of
    abelian groups. `homCechComplex 𝒰 F` is definitionally
    `(alternatingCofaceMapComplex Ab).obj ((cechFreeSimplicial 𝒰).rightOp ⋙ preadditiveYoneda.obj F)`
    — exactly `Hom_{PMod}(K(U)_•, F)`. `sectionCechComplex (coverOpen 𝒰) F` is `Č•(U, F)`.
    Match is faithful.
- **Proof follows sketch**: yes (partial formalism difference, mathematically identical)
  - Blueprint sketch (lines 1097–1132): (1) free-Yoneda identification per multi-index, (2) product
    over multi-indices, (3) differentials match by naturality of free-forgetful adjunction, assemble.
  - Lean proof: `(alternatingCofaceMapComplex Ab).mapIso (homCechSectionCosimplicialIso 𝒰 F)`.
    The blueprint's steps 1–3 are carried out in `homCechSectionIsoApp` (per-degree iso via
    `opCoproductIsoProduct`, `piComparison`, `freeYonedaHomAddEquiv`) and
    `homCechSectionCosimplicialIso` (cosimplicial naturality via `freeYonedaHomAddEquiv_naturality`).
    Applying `mapIso` then gives the complex iso with automatic differential intertwining — exactly
    the blueprint's assembly step. The mathematical content matches; Lean routes through the
    cosimplicial structure so the differential intertwining is structural rather than checked term-by-term.
- **Axiom scan**: `cechComplex_hom_identification` itself uses no axioms. `homCechSectionCosimplicialIso`
  and `homCechSectionIsoApp` use only standard Lean 4 axioms (`propext`, `Classical.choice`,
  `Quot.sound`) — all present in Mathlib baseline, no project-specific axioms.
- **notes**: `homCechSectionCosimplicialIso` (line 205) is the key intermediate not yet in the blueprint
  `\lean{}` list — this is the acknowledged coverage debt noted in the directive.

---

### `\lean{AlgebraicGeometry.homCechComplex}` (same block)

- **Lean target exists**: yes — line 124
- **Signature matches**: yes — `CochainComplex Ab.{u} ℕ`, the alternating-coface-map complex of
  `homCechCosimplicial 𝒰 F`; matches "the cochain complex obtained by applying the contravariant
  Hom(-, F) to K(U)_•" from the blueprint's intro of `homCechComplex`.
- **Proof follows sketch**: N/A (definition, not a proof)
- **notes**: well-formed, no sorry.

### `\lean{AlgebraicGeometry.homCechCosimplicial}` (same block)

- **Lean target exists**: yes — line 111
- **Signature matches**: yes — `CosimplicialObject Ab.{u}`, the right-op compose preadditiveYoneda
  transport of `cechFreeSimplicial`.
- **Proof follows sketch**: N/A (definition)
- **notes**: well-formed.

### `\lean{AlgebraicGeometry.homCechSectionIsoApp}` (same block)

- **Lean target exists**: yes — line 137
- **Signature matches**: yes — `(homCechCosimplicial 𝒰 F).obj n ≅ (sectionCechCosimplicial (coverOpen 𝒰) F).obj n`,
  the per-degree component of the Čech hom-identification. Matches blueprint description.
- **Proof follows sketch**: yes — uses `opCoproductIsoProduct`, `piComparison`, `freeYonedaHomAddEquiv`;
  exactly the coproduct–hom duality and free–Yoneda identification of the blueprint.
- **notes**: well-formed.

### `\lean{AlgebraicGeometry.homCechSectionIsoApp_hom_π}` (same block)

- **Lean target exists**: yes — line 156 (`private lemma homCechSectionIsoApp_hom_π`)
- **Signature matches**: yes — characterizes the projection of `homCechSectionIsoApp.hom` onto each
  `σ`-component. Matches blueprint's "characterizing property" description.
- **Proof follows sketch**: N/A (helper, no blueprint proof body to compare)
- **notes**: declared `private`. Blueprint lists it as `AlgebraicGeometry.homCechSectionIsoApp_hom_π`
  (full namespace), but `private` makes the name inaccessible from outside the file. See minor finding below.

### `\lean{AlgebraicGeometry.pi_mapIso_hom_eq}` (same block)

- **Lean target exists**: yes — line 149 (`private lemma pi_mapIso_hom_eq`)
- **Signature matches**: yes — states `(Limits.Pi.mapIso e).hom = Limits.Pi.map (fun b => (e b).hom)`.
- **Proof follows sketch**: N/A (definitional rfl, not a blueprint theorem)
- **notes**: declared `private`; same accessibility concern as above.

### `\lean{AlgebraicGeometry.freeYonedaHomAddEquiv_naturality}` (same block)

- **Lean target exists**: yes — line 179 (`private lemma freeYonedaHomAddEquiv_naturality`)
- **Signature matches**: yes — naturality of `freeYonedaHomAddEquiv` under restriction; this is the
  single naturality square that powers the cosimplicial comparison. Matches blueprint statement.
- **Proof follows sketch**: yes — the `ext ψ` + `rw [show PresheafOfModules.freeHomEquiv ...]` path
  is the expected mate-unfolding; blueprint says "naturality of the free–forgetful adjunction".
- **notes**: contains two pre-existing `linter.style.show` warnings at lines 185/187 (known per directive).
  Declared `private`; same accessibility concern.

---

## Red flags

No must-fix findings.

### Placeholder / suspect bodies
*(none)*

### Excuse-comments
*(none)* — The module-level prose at lines 29–43 lists planned declarations as "(planned)" in a
doc-comment; this is informational scaffolding, not an excuse-comment on live code.

### Axioms / Classical.choice on non-trivial claims
*(none)* — The only axioms present are `propext`, `Classical.choice`, `Quot.sound` (standard Lean 4
foundations, same as all of Mathlib). No project-specific axioms were introduced.

---

## Unreferenced declarations (informational)

| Declaration | Line | Status |
|---|---|---|
| `AlgebraicGeometry.homCechSectionCosimplicialIso` | 205 | **substantive helper** — the key intermediate for `cechComplex_hom_identification`. Not in the blueprint `\lean{}` list. Per directive this is known coverage debt from iter-019; the review agent should add it as a `lean_aux` node to `lem:cech_complex_hom_identification`. |

---

## Blueprint adequacy for this file

- **Coverage**: 7/7 CechBridge-resident declarations have a corresponding `\lean{}` block entry in
  `lem:cech_complex_hom_identification`. 1 substantive helper (`homCechSectionCosimplicialIso`)
  is not yet referenced (known debt). The three `freeYonedaHom*` declarations listed in the blueprint
  block live in `PresheafCech.lean`, not this file, and are excluded per directive.

- **Proof-sketch depth**: **adequate**. The blueprint proof at lines 1097–1132 covers (1) per-degree
  free–Yoneda identification, (2) product over multi-indices, (3) differential matching, and (4)
  naturality assembly — exactly the steps the Lean proof formalizes. The blueprint's prose gave a
  prover enough structure to find the cosimplicial-naturality route.

- **Hint precision**: **mostly precise** with one minor note. The `\lean{}` hint names three private
  declarations by their full external name (`AlgebraicGeometry.pi_mapIso_hom_eq`,
  `AlgebraicGeometry.homCechSectionIsoApp_hom_π`, `AlgebraicGeometry.freeYonedaHomAddEquiv_naturality`).
  Because these are `private`, the names do not exist in the external namespace; if blueprint tooling
  tries to resolve them externally it will fail. The declarations exist and are correct — just
  inaccessible by those names from outside the file.

- **Generality**: **slightly narrower than blueprint**. The blueprint states the lemma for an arbitrary
  ringed space `X` (consistent with the Stacks source), but the Lean formalization targets
  `X : Scheme.{u}`. This is an intentional project-scope restriction (the surrounding algebraic
  geometry API is scheme-specific) and does not create a gap for the project's use cases.

- **Recommended chapter-side actions**:
  - **Add** `AlgebraicGeometry.homCechSectionCosimplicialIso` as a `lean_aux` node to
    `lem:cech_complex_hom_identification` — it is the substantive intermediate, and its absence
    from the `\lean{}` list is the one coverage gap flagged here.
  - **Consider** whether the three private helpers should remain in the `\lean{}` list or be
    removed/noted as private. Since they cannot be resolved externally, a note in the blueprint
    that these are `private` helpers would improve accuracy.

---

## Severity summary

| Finding | Severity |
|---|---|
| `homCechSectionCosimplicialIso` not in `\lean{}` list (known per directive) | **major** |
| Three private helpers listed with external full names in `\lean{}` | **minor** |
| Lean targets `Scheme` vs blueprint's "ringed space" | **minor** (intentional) |
| Pre-existing `linter.style.show` warnings in `freeYonedaHomAddEquiv_naturality` | **minor** (known) |

**No must-fix-this-iter findings.**

**Overall verdict**: `cechComplex_hom_identification` is axiom-clean, its signature faithfully
matches the blueprint prose of `lem:cech_complex_hom_identification`, the proof strategy follows
the blueprint sketch, and no placeholder bodies or excuse-comments are present; the only actionable
item is adding `homCechSectionCosimplicialIso` as a `lean_aux` node to the blueprint block.
