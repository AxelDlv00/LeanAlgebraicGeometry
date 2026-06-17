# Lean ↔ Blueprint Check Report

## Slug
flatbasechange

## Iteration
232

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/FlatBaseChange.lean`
- Blueprint: `blueprint/src/chapters/Cohomology_FlatBaseChange.tex`

---

## Per-declaration

### `\lean{AlgebraicGeometry.pushforwardBaseChangeMap}` (chapter: `def:pushforward_base_change_map`)
- **Lean target exists**: yes
- **Signature matches**: yes  
  Type is `(pullback g).obj ((pushforward f).obj F) ⟶ (pushforward f').obj ((pullback g').obj F)`, i.e. `g^*(f_* F) → f'_*((g')^* F)`, matching the blueprint exactly. Takes `comm : g' ≫ f = f' ≫ g` (commutativity only, not cartesianness — a legitimate generalization over the blueprint's setup, since the map exists for any commutative square; the blueprint's cartesian assumption is only needed for the iso theorems).
- **Proof follows sketch**: yes  
  The body is the explicit adjoint-mate construction: `(pullbackPushforwardAdjunction g).homEquiv _ _).symm` applied to the chain `f_*(unit) ≫ pushforwardComp g' f ≫ pushforwardCongr comm ≫ (pushforwardComp f' g).inv`. This is precisely the blueprint's formula — apply `f_*` to the `((g')^*, (g')_*)`-adjunction unit, then use pseudofunctoriality of pushforward and commutativity of the square to land in `g_* f'_*`, then take the adjoint mate.
- **Notes**: GENUINE construction; no sorry; axiom-clean as far as the definition body goes. The `\leanok` on the definition block in the blueprint is correct (the definition exists and compiles).

---

### `\lean{AlgebraicGeometry.affineBaseChange_pushforward_iso}` (chapter: `lem:affine_base_change_pushforward`)
- **Lean target exists**: yes
- **Signature matches**: yes  
  `[IsAffineHom f]`, `h : IsPullback g' f' f g`, conclusion `IsIso (pushforwardBaseChangeMap f g f' g' h.w F)`. The blueprint says "f affine, base-change square cartesian (IsPullback) → the base-change map is an iso". Match is exact.
- **Proof follows sketch**: partial / N/A for the sorry remainder  
  The Lean proof opens with `rw [Scheme.Modules.Hom.isIso_iff_isIso_app]; intro U` — this is the correct first reduction (a morphism of sheaves of modules on S' is an iso iff it is so on sections over each open), which is a genuine and honest step toward the blueprint's localisation argument. The `sorry` that follows marks the missing Lean infrastructure: the affine dictionary translating `Scheme.Modules.pushforward`/`pullback` of tilde-modules into restriction-of-scalars/base-change of `ModuleCat` objects, plus a "locally iso on an affine cover → iso" criterion. The doc comment is transparent and accurate about exactly what is missing.
- **Notes**: `\leanok` on the *statement* block in the blueprint is correct (sorry present). The *proof* block in the blueprint has no `\leanok`, consistent with the proof not being closed.

---

### `\lean{AlgebraicGeometry.flatBaseChange_pushforward_isIso}` (chapter: `thm:flat_base_change_pushforward`)
- **Lean target exists**: yes
- **Signature matches**: yes  
  `h : IsPullback g' f' f g`, `[Flat g]`, `[QuasiCompact f]`, `[QuasiSeparated f]`, conclusion `IsIso (pushforwardBaseChangeMap f g f' g' h.w F)`. The blueprint (Stacks 02KH, `i = 0`) has exactly these hypotheses.
- **Proof follows sketch**: N/A (pure sorry, no partial steps)  
  The body is `sorry` with a doc comment outlining the strategy (Čech complex, flatness of `A → B`, term-wise identification via the affine lemma). The strategy matches the blueprint proof precisely. No reduction steps are attempted; this is correctly deferred.
- **Notes**: `\leanok` on the *statement* block is correct. The *proof* block has no `\leanok`. The doc comment describing the deferred strategy is accurate and matched against the blueprint proof.

---

## Red flags

None. No excuse-comments, no weakened-wrong definitions, no axioms, no suspect bodies.

The `sorry`-bodied theorems are expected scaffolding:
- Both carry `\leanok` on their statement blocks in the blueprint (sorry present = formalized at statement level, per project marker semantics).
- Both proof blocks are missing `\leanok` (proofs not closed).
- The inline strategy comments are informative and honest, not excusing wrong code.

---

## Unreferenced declarations (informational)

None. The file contains exactly three declarations (`pushforwardBaseChangeMap`, `affineBaseChange_pushforward_iso`, `flatBaseChange_pushforward_isIso`), and all three are `\lean{...}`-referenced in the chapter.

---

## Blueprint adequacy for this file

- **Coverage**: 3/3 Lean declarations have a corresponding `\lean{...}` block. Zero unreferenced declarations.
- **Proof-sketch depth**: adequate  
  The affine lemma blueprint proof gives the full algebraic argument (reduce locally to affine schemes, identify via the tilde-module dictionary, conclude from `(R' ⊗_R A) ⊗_A M ≅ R' ⊗_R M`). The flat theorem blueprint proof gives both the separated case (Čech complexes, term-wise affine base change, flatness) and the quasi-separated generalisation (Mayer–Vietoris / spectral sequence). The depth is sufficient to execute the proofs once the Lean infrastructure (affine dictionary, Čech complex for QCoh sheaves) is in place.
- **Hint precision**: precise  
  `\lean{...}` pins match the actual Lean names. The Mathlib predicates used (`IsPullback`, `IsAffineHom`, `Flat`, `QuasiCompact`, `QuasiSeparated`) are all correctly identified in the blueprint's prose ("affine morphism", "flat morphism", "quasi-compact and quasi-separated").
- **Generality**: matches need  
  The definition is stated for general commutative squares; the iso results are for cartesian squares. This is the right level.
- **Recommended chapter-side actions**: none. The chapter is adequate as written. The remaining work is Lean-infrastructure, not blueprint prose.

---

## Severity summary

No findings of any severity. The file is a clean scaffold: one genuine axiom-free definition and two honestly-sorry'd theorems, all signatures correct, all blueprint pins accurate, proof strategies documented and consistent with the blueprint.

**Overall verdict**: file and chapter are fully aligned — the scaffolding is correct; remaining work is Lean infrastructure (affine QCoh dictionary, Čech cohomology for `SheafOfModules`), not a blueprint or signature problem. 3 declarations checked, 0 red flags.
