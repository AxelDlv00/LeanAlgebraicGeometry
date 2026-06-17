# Lean ↔ Blueprint Check Report

## Slug
flattening303

## Iteration
303

## Files audited
- Lean: `AlgebraicJacobian/Picard/FlatteningStratification.lean`
- Blueprint: `blueprint/src/chapters/Picard_FlatteningStratification.tex`

---

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.CoherentSheafFlat}` (chapter: `def:coherent_sheaf_flat`)
- **Lean target exists**: yes (line 249)
- **Signature matches**: partial — `def CoherentSheafFlat {X S : Scheme.{u}} (f : X ⟶ S) (F : X.Modules) : Prop`. The blueprint says "a coherent `O_X`-module `F`"; the Lean binder is `F : X.Modules`, which is the full category of quasi-coherent `O_X`-modules with no coherence restriction. As a predicate definition this is technically acceptable (a predicate defined on a broader domain is not inherently wrong), but the definition omits the intended domain restriction and does not type-check the input as coherent.
- **Proof follows sketch**: N/A (definition, not a proof)
- **Notes**: Defining `CoherentSheafFlat` on all quasi-coherent sheaves rather than just coherent ones is a deliberate generality call that is defensible; the coherence input condition is instead needed as a hypothesis on every theorem that applies this predicate. No `sorry`, no red flag on the definition itself.

---

### `\lean{AlgebraicGeometry.genericFlatness}` (chapter: `thm:generic_flatness`)
- **Lean target exists**: yes (lines 287–294)
- **Signature matches**: **no — critical mismatch**

  Lean signature:
  ```lean
  theorem genericFlatness {S X : Scheme.{u}} [IsIntegral S] [IsLocallyNoetherian S]
      (p : X ⟶ S) [LocallyOfFiniteType p] (F : X.Modules) :
  ```

  Blueprint requires: `F` a **coherent** `O_X`-module, `p : X → S` **finite-type**.

  Issues, in order of severity:

  1. **`F : X.Modules` with no coherence hypothesis — statement is FALSE.**
     `X.Modules = SheafOfModules X.ringCatSheaf` is the full category of quasi-coherent `O_X`-modules; it includes infinite direct sums and other non-coherent objects. For arbitrary quasi-coherent `F`, the theorem is false: the direct sum $\bigoplus_{n \ge 0} O_X/I^n$ over a non-nilpotent ideal sheaf $I$ is quasi-coherent but has no non-empty open over which it becomes flat. The `sorry` body is therefore **unprovable** as the statement stands.

     The required Lean hypothesis is some form of coherence on `F`. Mathlib does not yet have a scheme-level `IsCoherentSheaf` predicate; the appropriate encoding in the current project would need to assert, affine-locally, that section modules are finitely presented (e.g. `Module.FinitePresentation Γ(X, V) Γ(F, V)` for every affine open `V`). A dedicated `IsCoherentModule` or `IsCoherent F` project-local typeclass on `F : X.Modules` is the expected fix.

  2. **`[LocallyOfFiniteType p]` vs blueprint's "finite-type" — minor discrepancy.**
     `LocallyOfFiniteType` (locally but not necessarily globally finite type; no quasi-compactness) is present and is WEAKER than `FiniteType` as a morphism property. This means the Lean statement requires less of `p` than the blueprint, making it harder to prove (more cases to cover). On a noetherian base, locally-of-finite-type morphisms satisfy the conclusion of generic flatness in standard references, so this could be correct, but it is a deliberate deviation from the blueprint's "finite-type" and should be documented.

- **Proof follows sketch**: N/A (body is `sorry`)
- **Notes**: The blueprint chapter itself (lines 165–172, inserted by the iter-303 review phase) already carries a `% NOTE` annotation confirming this defect. The declaration is NOT in `archon-protected.yaml`, so the planner may re-sign it. No prover should be sent to close this `sorry` until the signature is corrected.

---

### `\lean{AlgebraicGeometry.flatLocusStratification}` (chapter: `lem:flat_locus_stratification_lean`)
- **Lean target exists**: yes (lines 331–338)
- **Signature matches**: partial — `(F : S.Modules)` has no coherence hypothesis. Blueprint says "`F` a coherent `O_S`-module". Same defect as `genericFlatness`.
- **Proof follows sketch**: N/A (`sorry` body)
- **Notes**: The `lem:flat_locus_open` sub-lemma (Nitsure n=0) relies on Nakayama + a local finite presentation; without `F` coherent (finitely generated + finitely presented), Nakayama does not apply and the stratification does not exist.

---

### `\lean{AlgebraicGeometry.flatLocusReduction}` (chapter: `lem:flat_locus_reduction_lean`)
- **Lean target exists**: yes (lines 359–367)
- **Signature matches**: partial — `(F : X.Modules)` lacks coherence; `[IsProper π]` where blueprint uses `π : ℙⁿ_S → S` (projective, hence proper). The proper-for-projective substitution is documented in the file header as an acknowledged stand-in.
- **Proof follows sketch**: N/A (`sorry`)
- **Notes**: Same coherence defect. The proof of this lemma peels off flat patches via `genericFlatness`, which itself requires coherence; coherence of `F` is therefore transitively required here.

---

### `\lean{AlgebraicGeometry.flatLocusAssembly}` (chapter: `lem:flat_locus_assembly_lean`)
- **Lean target exists**: yes (lines 389–399)
- **Signature matches**: partial — `(F : X.Modules)` lacks coherence. Otherwise the conclusion (finite index set `I`, immersions with flat pullbacks, polynomial label `P : I → ℕ → ℤ` with injectivity) faithfully captures the assembly step.
- **Proof follows sketch**: N/A (`sorry`)
- **Notes**: Same coherence defect.

---

### `\lean{AlgebraicGeometry.flatteningStratification}` (chapter: `thm:flattening_stratification_exists`)
- **Lean target exists**: yes (lines 437–445)
- **Signature matches**: partial — two issues:
  1. `(F : X.Modules)` without coherence (same defect as above).
  2. The Lean conclusion encodes only existence of a finite locally-closed stratification with flatness (the essential content of Nitsure parts (i)+(ii) abstracted); it omits the **Hilbert-polynomial labeling** (no `P : I → ℕ → ℤ` injection here, unlike `flatLocusAssembly`) and the **closure-of-strata property** (Nitsure part (iii): closure of `|S_f|` is in `∪_{g≥f} |S_g|`). The full theorem as stated in the blueprint has all three parts; the Lean version is a strict weakening of the conclusion.
  3. `[IsProper π]` vs projective — accepted stand-in (documented in header).
- **Proof follows sketch**: N/A (`sorry`)
- **Notes**: The universal property (part (ii) of Nitsure) is factored into the separate `flatteningStratification_universal`, which is a reasonable factoring. But parts (i) and (iii) of Nitsure's theorem are not captured in either theorem — major gap in the conclusion.

---

### `\lean{AlgebraicGeometry.flatteningStratification_universal}` (chapter: `thm:flattening_stratification_universal`)
- **Lean target exists**: yes (lines 478–487)
- **Signature matches**: partial — two issues:
  1. `(F : X.Modules)` without coherence.
  2. The blueprint universal property is a **biconditional**: "`φ^* F` on `ℙⁿ_T` is `T`-flat **if and only if** `φ` factors uniquely through `i`". The Lean statement encodes only the forward direction (flat → factors):
     ```lean
     Scheme.CoherentSheafFlat (pullback.snd π φ) (...).obj F →
       ∃! (data : (f : I) × (T ⟶ S_ f)), data.2 ≫ ι data.1 = φ
     ```
     The converse direction (factors through a stratum → flat) is missing.
- **Proof follows sketch**: N/A (`sorry`)
- **Notes**: The converse direction is not in a separate Lean declaration either — it is simply absent.

---

### `\lean{AlgebraicGeometry.flatteningStratification.ofCurve}` (chapter: `cor:flattening_stratification_curve`)
- **Lean target exists**: yes (lines 517–530)
- **Signature matches**: partial — `(F : (Limits.pullback C.hom T.hom).Modules)` without coherence. Otherwise the shape (smooth proper curve over a field, noetherian T, finite stratification of T with flat pullbacks) matches the blueprint corollary.
- **Proof follows sketch**: N/A (`sorry`)
- **Notes**: Same coherence defect. Also missing the universal property of the stratification (only the existence part is stated, not part (ii)/(iii)).

---

### `\lean{AlgebraicGeometry.TODO.genericFlatnessAlgebraic}` (chapter: `thm:generic_flatness_algebraic`)
- **Lean target exists**: no — the `TODO` namespace pin `AlgebraicGeometry.TODO.genericFlatnessAlgebraic` names a declaration that does not exist in the file.
- **Signature matches**: N/A (absent)
- **Proof follows sketch**: N/A (absent)
- **Notes**: Explicitly a `TODO` placeholder in the blueprint. The three `GenericFreeness.*` lemmas are a partial step toward this theorem (the finite-morphism case), but they do not provide the full statement (`B` finite-type, not just module-finite over `A`). The gap — generic freeness for a finite module over a polynomial ring `A[X₁,…,X_d]` — is documented in the prover task result.

---

### `\lean{AlgebraicGeometry.TODO.flatLocusOpen}`, `TODO.nonflatLocusProper`, `TODO.noetherianInductionStrata`, `TODO.smoothProperCurveProjective`
All four are explicit `TODO`-namespace blueprint pins with no corresponding Lean declarations. These are known unformalized items; no finding.

---

## Red flags

### Signature defects (statements provably false as written)

The following declarations take `F : X.Modules` (or `F : S.Modules`) with **no coherence hypothesis**, making them false for general quasi-coherent sheaves and hence unprovable:

| Declaration | Line | Missing hypothesis |
|---|---|---|
| `AlgebraicGeometry.genericFlatness` | 287 | `[IsCoherent F]` or equivalent |
| `AlgebraicGeometry.flatLocusStratification` | 331 | `[IsCoherent F]` |
| `AlgebraicGeometry.flatLocusReduction` | 359 | `[IsCoherent F]` |
| `AlgebraicGeometry.flatLocusAssembly` | 389 | `[IsCoherent F]` |
| `AlgebraicGeometry.flatteningStratification` | 437 | `[IsCoherent F]` |
| `AlgebraicGeometry.flatteningStratification_universal` | 478 | `[IsCoherent F]` |
| `AlgebraicGeometry.flatteningStratification.ofCurve` | 517 | `[IsCoherent F]` |

All bodies are `sorry`. These sorries are **unprovable** until the signatures are corrected.

The blueprint `% NOTE (iter-303, review)` at `thm:generic_flatness` (blueprint lines 165–172) correctly identifies this defect for `genericFlatness`; this report extends the same classification to all six downstream declarations.

**Required fix**: Add a coherence predicate on `F` to each signature above. Since Mathlib does not yet have a scheme-level `IsCoherentSheaf` typeclass, the project must either:
- (a) Define a local `IsCoherentModule (F : X.Modules)` as an affine-local condition asserting `Module.FinitePresentation Γ(X, V) Γ(F, V)` for all affine opens `V`; or
- (b) Restrict the type of `F` to a subtype, e.g. using `X.LocallyFreeOfFiniteRank` as a stronger proxy where applicable; or
- (c) Add explicit `Module.FinitePresentation`/`Module.Finite` hypotheses on sections affine-locally.

None of these is in `archon-protected.yaml`, so all re-signings are authorized.

### Placeholder bodies
All seven scheme-level declarations carry `:= sorry` bodies. These are pre-existing from the iter-176 file-skeleton and acknowledged as iter-177+ work. They become additionally red-flagged because the statement is incorrect for six of them, not only incomplete.

---

## Unreferenced declarations (informational)

Three declarations in the Lean file have **no `\lean{...}` reference** in the blueprint:

| Declaration | Namespace | Notes |
|---|---|---|
| `GenericFreeness.exists_free_localizationAway_of_finite` | `AlgebraicGeometry` | Axiom-clean; the d=0/finite-module special case of `thm:generic_flatness_algebraic` |
| `GenericFreeness.exists_flat_localizationAway_of_finite` | `AlgebraicGeometry` | Axiom-clean; flatness corollary of the above |
| `GenericFreeness.exists_free_localizationAway_of_moduleFinite` | `AlgebraicGeometry` | Axiom-clean; the finite-morphism special case |

These are **substantive lemmas** (not trivial helpers), each with a non-trivial proof body and mathematical content. They should have `\lean{...}` entries in the blueprint. They are sub-results of `thm:generic_flatness_algebraic` and constitute a genuine partial step toward it; they belong anchored in `\S2` (Generic flatness, blueprint lines 86–204) as helper lemmas immediately before or within `thm:generic_flatness_algebraic`.

These lemmas cover only the **module-finite** case of `B` over `A` (i.e. `B` finite as an `A`-module, not merely `A`-algebra). The full theorem requires `B` finite-type (a strictly weaker hypothesis on `B`), so these lemmas do **not** close `thm:generic_flatness_algebraic` — they are its leaves in a prime-filtration dévissage argument.

---

## Blueprint adequacy for this file

- **Coverage**: 8 substantive Lean declarations; 8 have `\lean{...}` blocks (7 `\leanok`-marked with sorry bodies; 1 with `TODO` pin). 3 additional axiom-clean declarations have no blueprint entry — these are substantive and should be anchored.
- **Proof-sketch depth**: **under-specified** on one critical dimension: the blueprint states `F` is coherent throughout every theorem but gives no guidance on which Lean typeclass encodes coherence for `X.Modules`. This gap directly caused the coherence hypothesis to be dropped from all seven theorem signatures in the file skeleton. The blueprint's `\lean{AlgebraicGeometry.genericFlatness}` pin does not indicate what typeclass condition should appear next to `(F : X.Modules)`. This is a blueprint clarity failure that compounded the signature defect.
- **Hint precision**: **loose** for the coherence hypothesis — the blueprint says "`\F` a coherent `\OO_X`-module" in prose but the `\lean{...}` pin gives no indication of how coherence is encoded in Lean, leaving the prover to decide. The consequence was all seven signatures being drafted without coherence.
- **Generality**: **matches need** for the stratification conclusions; **too loose** on the input (no coherence restriction specified).
- **Recommended chapter-side actions** (for the blueprint-writing subagent):
  1. Add a dedicated subsection in `\S2` anchoring the three `GenericFreeness.*` lemmas with `\lean{...}` pins:
     - `\lean{AlgebraicGeometry.GenericFreeness.exists_free_localizationAway_of_finite}`
     - `\lean{AlgebraicGeometry.GenericFreeness.exists_flat_localizationAway_of_finite}`
     - `\lean{AlgebraicGeometry.GenericFreeness.exists_free_localizationAway_of_moduleFinite}`
     Note explicitly that these cover only the module-finite case (a special case of `thm:generic_flatness_algebraic`, not a proof of it).
  2. Amend every `\lean{...}`-pinned theorem and lemma that takes a coherent sheaf input (`thm:generic_flatness`, `lem:flat_locus_stratification_lean`, `lem:flat_locus_reduction_lean`, `lem:flat_locus_assembly_lean`, `thm:flattening_stratification_exists`, `thm:flattening_stratification_universal`, `cor:flattening_stratification_curve`) to include an explicit annotation specifying the Lean coherence typeclass or predicate to be added, e.g. `% Lean: add [IsCoherent F] where IsCoherent is project-defined as ...`. This directs the prover without ambiguity.
  3. Add a small `\S1.5` or remark documenting the Mathlib absence of `IsCoherentSheaf` for `Scheme.Modules` and specifying the project-local encoding to use (affine-local `Module.FinitePresentation` quantifier, or a dedicated typeclass).
  4. The conclusion of `thm:flattening_stratification_exists` should note that the Lean encoding captures only the existence/flatness conjunct (not the Hilbert-polynomial labeling or closure-of-strata parts (i)/(iii)), to set correct expectations for readers.
  5. The converse direction of `thm:flattening_stratification_universal` ("factors through a stratum → flat") should be explicitly stated as a separate Lean conjunct or noted as out-of-scope for this iter.

---

## Severity summary

### must-fix-this-iter
1. **`genericFlatness` (line 287)**: `F : X.Modules` missing coherence — statement is FALSE; sorry unprovable.
2. **`flatLocusStratification` (line 331)**: `F : S.Modules` missing coherence — same defect.
3. **`flatLocusReduction` (line 359)**: `F : X.Modules` missing coherence — same defect.
4. **`flatLocusAssembly` (line 389)**: `F : X.Modules` missing coherence — same defect.
5. **`flatteningStratification` (line 437)**: `F : X.Modules` missing coherence — same defect.
6. **`flatteningStratification_universal` (line 478)**: `F : X.Modules` missing coherence — same defect.
7. **`flatteningStratification.ofCurve` (line 517)**: `F` missing coherence — same defect.
8. **Blueprint adequacy**: chapter omits specification of which Lean typeclass encodes coherence, directly causing the above seven defects; chapter-side fix required before re-dispatching any prover on these declarations.

### major
1. Three `GenericFreeness.*` lemmas (axiom-clean, substantive) have no `\lean{...}` entry in the blueprint — blueprint coverage gap.
2. `flatteningStratification` conclusion omits the Hilbert-polynomial labeling (present in `flatLocusAssembly` but dropped here) and the closure-of-strata property (Nitsure part (iii)).
3. `flatteningStratification_universal` encodes only the "flat → factors" direction; the converse is absent from the file entirely.
4. `LocallyOfFiniteType p` vs blueprint's "finite-type `p`" — weaker hypothesis that increases the proof burden; should be reconciled with the blueprint (confirm `LocallyOfFiniteType` suffices or upgrade to `[LocallyOfFiniteType p] [QuasiCompact p]`).

### minor
- Blueprint's `% NOTE (iter-303, review)` at `thm:generic_flatness` says "NO coherence / finite-type hypothesis" but `[LocallyOfFiniteType p]` IS present in the Lean file — the note slightly misstates the finite-type situation. No action needed on the Lean side; note could be corrected to "NO coherence hypothesis on `F`; the morphism hypothesis is `LocallyOfFiniteType` (weaker than `FiniteType`)."

**Overall verdict**: The file has seven declarations with a common must-fix coherence-hypothesis defect (all statements are false as written; sorry bodies are unprovable), plus three substantive axiom-clean lemmas that are undocumented in the blueprint — re-signing all seven theorem/lemma signatures and adding blueprint entries for the three `GenericFreeness.*` lemmas are the required actions before any prover work can proceed on this file.
