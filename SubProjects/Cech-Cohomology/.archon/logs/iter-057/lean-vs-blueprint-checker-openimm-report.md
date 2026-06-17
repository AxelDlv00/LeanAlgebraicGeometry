# Lean ↔ Blueprint Check Report

## Slug
openimm

## Iteration
057

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/OpenImmersionPushforward.lean`
- Blueprint: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`
  (blocks: `lem:open_immersion_pushforward_comp`, `lem:modules_isoSpec_ext_transport`,
  and supporting `lem:ext_mapExactFunctor_mathlib`, `lem:modules_pushforward_mathlib`)

---

## Per-declaration

### `\lean{AlgebraicGeometry.modulesIsoSpecExtTransport}` (chapter: `lem:modules_isoSpec_ext_transport`)

- **Lean target exists**: yes — `modulesIsoSpecExtTransport` at line 241, axiom-clean, no sorry.
- **Signature matches**: partial. The blueprint statement specifies the specialized form
  `Ext^q_U(j_! O_V, H) ≅ Ext^q_{Spec Γ U}(j_! O_{V'}, H')` (with A fixed as `jShriekOU V` and B as
  a quasi-coherent module H). The Lean declaration takes **general** `(A B : U.Modules)` and
  transports them via `pushforwardEquivOfIso U.isoSpec`. The Lean is strictly more general (the
  blueprint's specialized form follows by taking A = jShriekOU V, B = H), and the `\lean{}` hint
  names the correct declaration, but the informal statement mis-specifies the signature as
  specialized.
- **Proof follows blueprint sketch**: partial/no for the mechanism. The blueprint `\begin{proof}`
  says "An equivalence is exact, so `Ext.mapExactFunctor` applied to Φ and its quasi-inverse gives
  mutually inverse maps on Ext, hence the displayed isomorphism." This describes a
  functor-composition route that does NOT exist in Mathlib
  (`Ext.mapExactFunctor` has no composition-of-two-maps lemma). The Lean instead uses
  `Functor.mapExt_bijective_of_preservesInjectiveObjects` + `AddEquiv.ofBijective`, which is
  mathematically equivalent but takes a completely different Mathlib path. The statement block
  carries a `% NOTE:` acknowledging the divergence, so it is not hidden, but the proof body itself
  is factually inaccurate about the mechanism used.
- **notes**:
  - The `% NOTE:` comment (lines 8987–8989 of the blueprint) correctly records the actual Lean
    route and the `[EnoughInjectives]` requirement; the proof prose body does not.
  - The blueprint proof body also describes "It remains to identify the images of the two arguments
    … Φ(j_! O_V) ≅ j_! O_{V'} …" as though this identification is part of the proof of
    `modulesIsoSpecExtTransport`. The Lean declaration deliberately omits this (it takes arbitrary
    A, B and makes no claim about jShriekOU naturality); the Lean docstring (lines 235–240)
    explicitly labels it "handed off" as an orthogonal residual. The blueprint proof body therefore
    misrepresents what `modulesIsoSpecExtTransport` establishes.
  - `\leanok` is absent from the statement block despite the declaration being axiom-clean. The
    `sync_leanok` phase should add this; the `% NOTE:` comment may have disrupted the scanner.

---

### `\lean{AlgebraicGeometry.higherDirectImage_openImmersion_acyclic}` (chapter: `lem:open_immersion_pushforward_comp`, part 1)

- **Lean target exists**: yes — `higherDirectImage_openImmersion_acyclic` at line 317.
- **Signature matches**: yes. The Lean signature matches the blueprint statement: `j : U ↪ X` open
  immersion, `[IsAffine U]`, `[X.IsSeparated]`, `H : U.Modules`, `hH : H.IsQuasicoherent`,
  `q : ℕ`, `hq : 0 < q` → `IsZero (higherDirectImage j q H)`.
- **Proof follows blueprint sketch**: partial (residual sorry). The proof is wired through the
  presheaf description → sheafification-reflect → sectionwise-locally-zero site lemma, following
  the blueprint sketch faithfully up to the residual. The one `sorry` at line 373 is **honest**: it
  sits at exactly the gap the blueprint identifies as the hard piece: the Bridge(1)/(2)
  identification `(preadditiveCoyoneda (op P)).rightDerived q ≅ Ext^q(P,-)` plus the jShriekOU
  naturality under the scheme iso (`Φ(jShriekOU V) ≅ jShriekOU V'`), followed by the general-affine
  Serre vanishing (`affine_serre_vanishing_general_open`). The proof comment at lines 364–372
  documents the residual precisely.
- **notes**: The sorry goal is correctly typed (it is a non-trivial `IsZero` claim on a derived
  functor applied to a genuine object, not a trivially-dischargeable goal).

---

### `\lean{AlgebraicGeometry.higherDirectImage_openImmersion_comp}` (chapter: `lem:open_immersion_pushforward_comp`, part 2)

- **Lean target exists**: yes — `higherDirectImage_openImmersion_comp` at line 415.
- **Signature matches**: yes. The Lean signature matches the blueprint: `j : U ↪ X` open
  immersion, `[IsAffine U]`, `[X.IsSeparated]`, `f : X ⟶ S`, `H : U.Modules`,
  `hH : H.IsQuasicoherent`, `k : ℕ` → `higherDirectImage f k ((pushforward j).obj H) ≅
  higherDirectImage (j ≫ f) k H`.
- **Proof follows blueprint sketch**: no (entire body is sorry). The `sorry` at line 439 is
  **honest**: the proof comment (lines 421–438) documents the complete assembly plan and labels both
  residuals (a) and (b) as depending on Part (1)'s residual sorry. The sorry is not a placeholder
  for a trivially-known argument; it is gated on the same jShriekOU-naturality/Ext-vanishing chain
  as Part (1).
- **notes**: The `higherDirectImage_openImmersion_comp` declaration body is essentially a
  well-annotated plan sorry; the annotations are accurate and match the blueprint's proof sketch.

---

### `\lean{AlgebraicGeometry.isAffineHom_of_affine_separated}` (chapter: `lem:open_immersion_pushforward_comp`, ancillary)

- **Lean target exists**: yes — `isAffineHom_of_affine_separated` at line 275 (private lemma).
- **Signature matches**: yes. Matches the blueprint's claim "j is an affine morphism (open
  immersion of an affine into a separated scheme)".
- **Proof follows blueprint sketch**: yes — the proof is 5 lines and closed.
- **notes**: Marked `private`; the blueprint lists it publicly in `\lean{...}`. Informational only
  — private Lean helpers can still be registered as `\lean{...}` targets; no action needed.

---

## Red flags

### Placeholder / suspect bodies
None. Both sorries (`_acyclic` line 373, `_comp` line 439) correspond to declared residuals that the
blueprint explicitly acknowledges as open; neither is a placeholder on a claim the blueprint
considers established.

### Excuse-comments
None detected. The inline comments at lines 364–372 and 421–438 document genuine open subgoals,
not work-arounds for wrong code.

### Axioms / Classical.choice on non-trivial claims
None. All four new declarations (`pushforwardEquivOfIso`, `pushforwardEquivOfIso_functor_additive`,
`pushforwardExtAddEquiv`, `modulesIsoSpecExtTransport`) are axiom-clean per the directive.

---

## Unreferenced declarations (informational)

The following declarations in the Lean file have no direct `\lean{...}` reference in the blueprint
(they are supporting helpers):

| Declaration | Line | Nature |
|---|---|---|
| `CategoryTheory.Functor.isZero_of_faithful_preservesZeroMorphisms` | 42 | Mathlib supplement (local copy from CechAugmentedResolution) |
| `CategoryTheory.GrothendieckTopology.isZero_presheafToSheaf_of_sections_locally_zero` | 71 | Has its own `lem:isZero_presheafToSheaf_of_sections_locally_zero` block with `\leanok` — correctly referenced |
| `AlgebraicGeometry.jShriekOU_homEquiv_nat` | 126 | Private; registered at `lem:open_immersion_pushforward_comp` via usage |
| `AlgebraicGeometry.toPresheafOfModules_additive` | 141 | Instance helper; not separately blueprinted, acceptable |
| `AlgebraicGeometry.sectionsFunctor_additive` | 148 | Instance helper; not separately blueprinted, acceptable |
| `AlgebraicGeometry.sectionsFunctorCorepIso` | 160 | Has its own blueprint block `lem:sectionsFunctorCorepIso` — correctly referenced |
| `AlgebraicGeometry.rightDerivedNatIso` | 178 | Has its own blueprint block `lem:rightDerivedNatIso` — correctly referenced |
| `AlgebraicGeometry.Scheme.Modules.pushforwardEquivOfIso` | 204 | **Substantive** — implements the equivalence described in the blueprint's `lem:modules_isoSpec_ext_transport` proof. No direct `\lean{...}` tag. Blueprint describes it in prose under `lem:modules_pushforward_mathlib` coherences but does not pin it as a Lean target. Worth adding `\lean{AlgebraicGeometry.Scheme.Modules.pushforwardEquivOfIso}` or a dedicated sub-lemma. |
| `AlgebraicGeometry.pushforwardEquivOfIso_functor_additive` | 214 | Additive instance; helper |
| `AlgebraicGeometry.Scheme.Modules.pushforwardExtAddEquiv` | 223 | **Substantive** — the generic Ext-transport via equivalence. No direct `\lean{...}` tag. `modulesIsoSpecExtTransport` is just its specialization to `U.isoSpec`; worth a blueprint sub-block. |
| `AlgebraicGeometry.pushforwardSectionsFunctor` | 288 | Has blueprint block `lem:pushforward_sections_functor` — correctly referenced |
| `AlgebraicGeometry.pushforwardSectionsFunctor_additive` | 295 | Instance helper |

`pushforwardEquivOfIso` and `pushforwardExtAddEquiv` are substantive enough to merit explicit
blueprint sub-lemmas or `\lean{...}` tags; they are currently described only in the prose narrative
of `lem:modules_isoSpec_ext_transport`'s proof.

---

## Blueprint adequacy for this file

- **Coverage**: 5/6 primary Lean declarations have a corresponding `\lean{...}` block.
  `pushforwardEquivOfIso` and `pushforwardExtAddEquiv` are the unreferenced substantive
  declarations (see above). Unreferenced helpers (instances, private lemmas): acceptable.
- **Proof-sketch depth**: **under-specified** for `lem:modules_isoSpec_ext_transport`.
  - The proof body claims `Ext.mapExactFunctor` composition as the route. That route requires a
    Mathlib lemma (`Ext.mapExactFunctor` applied twice gives mutually inverse maps) that does not
    exist in the current Mathlib. The `% NOTE:` comment correctly identifies
    `mapExt_bijective_of_preservesInjectiveObjects` as the actual route, but the proof body is not
    updated to match. A prover reading the proof body without the `% NOTE:` would be misled.
  - The proof body describes `Φ(jShriekOU V) ≅ jShriekOU V'` (jShriekOU naturality under scheme
    iso) as established by this lemma's proof. It is not: the Lean declaration deliberately omits
    this (it takes general A, B), and the docstring labels this identification as "handed off" — a
    separate open residual. The blueprint's proof body creates a false impression that
    `modulesIsoSpecExtTransport` closes the jShriekOU-naturality gap.
- **Hint precision**: **loose** for `lem:modules_isoSpec_ext_transport`. The `\lean{...}` hint
  correctly names the declaration, but the informal statement describes a specialized form
  (A = jShriekOU V, B = quasi-coherent H) while the Lean has a more general signature (arbitrary
  A, B). The prose also omits `[EnoughInjectives]` from the formal hypothesis list (it's only in
  the `% NOTE:` comment).
- **jShriekOU naturality — blueprint gap**: The identification
  `Φ(jShriekOU V) ≅ jShriekOU V'` (naturality of j_! O_{(-)} under a scheme iso) is described in
  the blueprint proof body of `lem:modules_isoSpec_ext_transport` as a completed step. It is not
  formalized anywhere: the Lean explicitly carves it out as the "remaining hard piece". This gap is
  not blueprinted as a standalone claim; it is the jShriekOU-naturality residual that blocks the
  `_acyclic` sorry. A standalone lemma block for this naturality (e.g.
  `lem:jShriekOU_naturality_iso`) is needed.
- **Generality**: **matches need** for the Lean. The Lean's choice to state
  `pushforwardExtAddEquiv` and `modulesIsoSpecExtTransport` in terms of general A, B is correct and
  more reusable than the blueprint's specialized statement.
- **Recommended chapter-side actions**:
  1. **Update the `\begin{proof}...\end{proof}` body of `lem:modules_isoSpec_ext_transport`** to
     replace the `Ext.mapExactFunctor` composition description with the actual route:
     "`mapExt_bijective_of_preservesInjectiveObjects` upgrades `mapExtAddHom` to an isomorphism
     because the equivalence functor preserves injective objects; `AddEquiv.ofBijective` packages
     this into the `≃+`." Move the `% NOTE:` content into the prose.
  2. **Add `[EnoughInjectives U.Modules]` to the prose statement** of
     `lem:modules_isoSpec_ext_transport`, not only in a `% NOTE:` comment.
  3. **Generalize the statement** of `lem:modules_isoSpec_ext_transport` to match the Lean:
     "for any A, B : U.Modules" rather than fixing A = jShriekOU V, B = H, and note that the
     jShriekOU-naturality identification is a *separate* residual, not part of this lemma.
  4. **Add a blueprint block for `pushforwardEquivOfIso`** (the generic scheme-iso → module
     equivalence construction) with `\lean{AlgebraicGeometry.Scheme.Modules.pushforwardEquivOfIso}`
     and a note about its role in `pushforwardExtAddEquiv`.
  5. **Add a blueprint block or `% NOTE:` for the jShriekOU-naturality residual**, clearly labelled
     as a separate open gap: `Φ(jShriekOU V) ≅ jShriekOU V'` under a scheme iso. This is
     currently the primary blocking residual for `_acyclic`'s sorry and should be tracked
     explicitly.
  6. **Run `sync_leanok`** to add `\leanok` to the statement block of
     `lem:modules_isoSpec_ext_transport` (the declaration is axiom-clean; the marker is missing).

---

## Severity summary

| Finding | Severity |
|---|---|
| Blueprint proof body of `lem:modules_isoSpec_ext_transport` describes wrong Ext-transport mechanism (`Ext.mapExactFunctor` composition vs actual `mapExt_bijective_of_preservesInjectiveObjects`) | **major** |
| Blueprint proof body falsely implies `modulesIsoSpecExtTransport` establishes `Φ(jShriekOU V) ≅ jShriekOU V'`; Lean explicitly hands this off as an open residual | **major** |
| `[EnoughInjectives]` requirement documented only in `% NOTE:`, absent from prose statement | **minor** |
| Blueprint statement specifies specialized form (A = jShriekOU V, B = H) while Lean has more general signature (arbitrary A, B) | **minor** |
| `pushforwardEquivOfIso` and `pushforwardExtAddEquiv` are substantive, unreferenced declarations with no `\lean{...}` tag | **minor** |
| `\leanok` missing from `lem:modules_isoSpec_ext_transport` statement block (sync_leanok gap) | **minor** |
| jShriekOU naturality under scheme iso not blueprinted as a standalone claim | **major** |

Both Lean-side `sorry`s (`_acyclic` line 373, `_comp` line 439) are honest holes with correctly-typed
goals; no must-fix-this-iter issues on the Lean side.

**Overall verdict**: The Lean file is clean and faithful to the blueprint's intent; all four new Need
#1 declarations are axiom-clean and correctly placed, and the two pre-existing sorries are honest.
The blueprint chapter has three **major** adequacy failures: the `lem:modules_isoSpec_ext_transport`
proof body describes a wrong Mathlib route, incorrectly claims the jShriekOU-naturality
identification as proved by the lemma, and has no standalone blueprint block for the jShriekOU
naturality residual that is the primary blocker for the `_acyclic` sorry.
