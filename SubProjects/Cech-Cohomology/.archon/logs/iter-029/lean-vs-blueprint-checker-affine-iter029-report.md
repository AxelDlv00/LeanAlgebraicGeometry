# Lean ↔ Blueprint Check Report

## Slug
affine-iter029

## Iteration
029

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/AffineSerreVanishing.lean`
- Blueprint: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`
  (section `\subsection{The affine instantiation (Tag 02KG)}`, approximately lines 3198–3423)

---

## Per-declaration

### `\lean{AlgebraicGeometry.affine_faces_mem}` (chapter: `lem:affine_faces_mem`)

- **Lean target exists**: yes
- **Signature matches**: yes — Lean states `(⨅ k, PrimeSpectrum.basicOpen (s (σ k))) ∈ Set.range (fun f => PrimeSpectrum.basicOpen f)` for arbitrary `(s : ι → R)` and multi-index `σ : Fin (p+1) → ι`. Blueprint says the (p+1)-fold intersection of basic opens `D(s_{σ k})` is a basic open `D(∏ k s_{σ k})`, i.e. lies in the basis. The membership-in-range shape matches the `faces_mem` field requirement.
- **Proof follows sketch**: yes — one-liner `⟨∏ k, s (σ k), (basicOpen_sprod (p+1) s σ).symm⟩`. Blueprint sketch says "iterate D(f)∩D(g)=D(fg)"; this is exactly `basicOpen_sprod`.
- **Notes**: `\leanok` on both statement and proof block — consistent with the axiom-clean decl. No issues.

---

### `\lean{AlgebraicGeometry.coverDatum_bridge}` (chapter: `lem:cover_datum_bridge`)

- **Lean target exists**: **no** — the declaration `coverDatum_bridge` does not exist in the Lean file.
- **Partial substitute present**: `coverOpen_affineOpenCoverOfSpan` was formalized (axiom-clean): it proves `coverOpen 𝒰 i = PrimeSpectrum.basicOpen (s i)` (the pointwise open equality). This is the open-level half of `lem:cover_datum_bridge`.
- **Signature matches**: N/A (full decl absent). The shipped `coverOpen_affineOpenCoverOfSpan` is weaker than the block's claim (full section-Čech-complex identification).
- **Proof follows sketch**: N/A.
- **Notes**:
  - The blueprint block already has a `% NOTE: (review iter-029)` at lines 3333–3340 documenting this situation: the prover applied the open-level identity inline (via `funext`) inside `affine_injective_acyclic` rather than as a standalone complex-identification decl.
  - No `\leanok` on the block — consistent (since `coverDatum_bridge` is absent).
  - `coverOpen_affineOpenCoverOfSpan` is **unreferenced** by any `\lean{...}` block (see Coverage Debt below).

---

### `\lean{AlgebraicGeometry.affine_injective_acyclic}` (chapter: `lem:affine_injective_acyclic`)

- **Lean target exists**: yes
- **Signature matches**: **partial** — see scope mismatch below.
- **Proof follows sketch**: yes — proof follows the blueprint's "bridge + apply injective_cech_acyclic" outline:
  1. `hbridge` establishes `fun i => D(s i) = coverOpen 𝒰` (using `coverOpen_affineOpenCoverOfSpan`).
  2. Rewrites `cechCohomology` along `hbridge`.
  3. Applies `injective_cech_acyclic` for the `OpenCover` form.
- **Scope mismatch (major)**:
  - The **Lean signature** has `(hs : Ideal.span (Set.range s) = ⊤)`, which restricts to families covering the *whole* `Spec R` (the top cover, `D(1)`). The proof uses `Scheme.affineOpenCoverOfSpanRangeEqTop s hs` which requires exactly this spanning condition.
  - The **blueprint** prose says "every injective O_X-module has vanishing Čech cohomology over **every standard cover 𝒰 ∈ Cov**", and claims this "discharges the `injective_acyclic` field of the affine cover system."
  - The **`BasisCovSystem.injective_acyclic`** field (in `CechToCohomology.lean` lines 338–339) requires: `∀ (I : X.Modules), Injective I → ∀ c ∈ Cov, ∀ q, 0 < q → IsZero (cechCohomology c.2 ...)`. Since `affineCoverSystem.Cov` must include **standard covers of ALL distinguished opens** `D(f)` (not just `D(1) = Spec R`), this field requires acyclicity for covers of proper `D(f)` — which `hs : Ideal.span (Set.range s) = ⊤` does NOT encode (that condition is over `R`, not `R_f`).
  - The Lean docstring is self-aware: it says "this is the affine instantiation of `injective_cech_acyclic` **for standard covers of the whole affine**." But the blueprint block does not reflect this limitation.
  - The `\leanok` is correctly set (the limited decl is axiom-clean); the issue is the blueprint's *overclaim* about what it achieves.

---

### Unbuilt: `\lean{AlgebraicGeometry.standard_cover_cofinal}` (chapter: `lem:standard_cover_cofinal`)

- **Lean target exists**: no — not in `AffineSerreVanishing.lean` (expected gap for this iteration).
- **Blueprint sketch adequate?**: yes — argument is clear: quasi-compactness of `D(f)` + distinguished opens form a basis → any cover refines to a finite standard cover. Stacks Lemma lemma-standard-open (2) cited. Formalizable.

---

### Unbuilt: `\lean{AlgebraicGeometry.affine_surj_of_vanishing}` (chapter: `lem:affine_surj_of_vanishing`)

- **Lean target exists**: no (expected gap).
- **Blueprint sketch adequate?**: yes — two-step: invoke `standard_cover_cofinal` to get a cofinal system of standard covers, then apply `ses_cech_h1`. Blocked on `standard_cover_cofinal`.

---

### Unbuilt: `\lean{AlgebraicGeometry.affineCoverSystem}` (chapter: `def:affine_cover_system`)

- **Lean target exists**: no (expected gap).
- **Blueprint sketch adequate?**: **partially misleading** — the blueprint says to discharge `injective_acyclic` using `lem:affine_injective_acyclic`, but (as documented under `affine_injective_acyclic` above) the landed decl only handles the ⊤-cover case. Any prover following the blueprint will find they cannot close the `injective_acyclic` field for covers of proper `D(f)`. The blueprint needs a `% NOTE:` and a plan for a more general `affine_injective_acyclic` (or a restriction of `Cov`).

---

### Unbuilt: `\lean{AlgebraicGeometry.affine_serre_vanishing}` (chapter: `lem:affine_serre_vanishing`)

- **Lean target exists**: no (expected gap).
- **Blueprint sketch adequate?**: yes, once `affineCoverSystem` and `affine_cech_vanishing_qcoh` are available. Sketch is clean (plug into `cech_to_cohomology_on_basis` / `absoluteCohomology_eq_zero_of_basis`). Note that `[EnoughInjectives X.Modules]` hypothesis is correctly flagged in the block.

---

## Red flags

None in the Lean file.

- No `sorry` declarations.
- No `axiom` declarations.
- No excuse-comments ("-- TODO: replace", "-- temporary", "-- placeholder", etc.).
- No suspect bodies (`:= True`, `:= rfl` on non-trivial claims).

---

## Unreferenced declarations (informational)

### `AlgebraicGeometry.coverOpen_affineOpenCoverOfSpan` — **substantive, needs `\lean{...}` block**

This declaration (lines 53–62) proves `coverOpen (affineOpenCoverOfSpanRangeEqTop s hs).openCover i = PrimeSpectrum.basicOpen (s i)`. It is:
- Axiom-clean, substantive, used internally in `affine_injective_acyclic`.
- Not a mere local helper — it is the open-level half of `lem:cover_datum_bridge`.
- Already identified as "coverage debt" by the `% NOTE:` in `lem:cover_datum_bridge` (blueprint lines 3333–3340).

The plan agent should either: (a) repin `lem:cover_datum_bridge` to `\lean{AlgebraicGeometry.coverOpen_affineOpenCoverOfSpan}` with an adjusted statement (open equality, not complex identification), or (b) add a new lemma block for it. The current `\lean{AlgebraicGeometry.coverDatum_bridge}` reference is a dangling pin.

---

## Blueprint adequacy for this file

- **Coverage**: 2/3 landed Lean declarations have a `\lean{...}` block (`affine_faces_mem`, `affine_injective_acyclic`). 1 declaration (`coverOpen_affineOpenCoverOfSpan`) is unreferenced — coverage debt documented in the blueprint's `% NOTE:`.
- **Proof-sketch depth**: **adequate** for the 3 landed decls; **adequate** for `standard_cover_cofinal` and `affine_surj_of_vanishing`; **misleading** for `def:affine_cover_system` (see scope mismatch above).
- **Hint precision**: **loose → wrong** for `lem:cover_datum_bridge`: the `\lean{AlgebraicGeometry.coverDatum_bridge}` pin names a non-existent declaration. The `% NOTE:` acknowledges this but the `\lean{...}` tag was not yet corrected.
- **Generality**: **too narrow for `lem:affine_injective_acyclic`**: the Lean decl covers `hs : Ideal.span (Set.range s) = ⊤` (⊤-cover) but the `injective_acyclic` field of `BasisCovSystem` (line 338 of `CechToCohomology.lean`) requires the property for ALL `c ∈ Cov`, which includes standard covers of proper distinguished opens `D(f)`. The missing general statement must either:
  - Reduce a cover `D(g_i)` of `D(f)` to a cover of `Spec(R_f)` satisfying the ⊤-condition in `R_f`, or
  - Restrict `affineCoverSystem.Cov` to only cover the whole `Spec R` and redesign `surj_of_vanishing` accordingly (unlikely to work, since `ses_cech_h1` needs cofinal covers of each `D(f)`).

### Recommended chapter-side actions

1. **Correct the dangling `\lean{...}` pin in `lem:cover_datum_bridge`**: Change `\lean{AlgebraicGeometry.coverDatum_bridge}` to `\lean{AlgebraicGeometry.coverOpen_affineOpenCoverOfSpan}` and revise the statement to the open-level equality `coverOpen 𝒰 i = D(s i)`. Or add a new lemma block for `coverOpen_affineOpenCoverOfSpan` and keep `coverDatum_bridge` as a future target.

2. **Add a `% NOTE:` to `lem:affine_injective_acyclic`** documenting that the landed decl handles only the ⊤-cover case (`hs : Ideal.span (Set.range s) = ⊤`), and that a more general version is needed for covers of proper `D(f)` in order to discharge the `BasisCovSystem.injective_acyclic` field of `affineCoverSystem`. The natural route: reduce a cover `D(g_i)` of `D(f)` to `Ideal.span (Set.range (g_i \bmod R_f)) = ⊤` in `R_f`, then apply `affine_injective_acyclic` for `Spec(R_f)`.

3. **Add a `% NOTE:` to `def:affine_cover_system`** noting that building the `injective_acyclic` field requires a more general `affine_injective_acyclic` statement (or a restricted `Cov`), since the current decl does not cover proper distinguished opens.

4. **Remove the incorrect `\leanok` context implication**: The `\leanok` on `lem:affine_injective_acyclic`'s statement and proof blocks is technically correct (the limited decl IS axiom-clean), but the block prose creates a false impression that the `injective_acyclic` field of `affineCoverSystem` is fully discharged.

---

## Severity summary

| Finding | Severity |
|---------|----------|
| `lem:cover_datum_bridge` pins non-existent `coverDatum_bridge`; `coverOpen_affineOpenCoverOfSpan` is unreferenced | **major** |
| `lem:affine_injective_acyclic` prose overclaims scope ("every standard cover") vs. Lean (⊤-cover only); `def:affine_cover_system` construction will be blocked by this gap when attempted | **major** |
| No `sorry`, no axioms, no excuse-comments in Lean file | (none) |

**Overall verdict**: The 3 landed declarations in `AffineSerreVanishing.lean` are correct and follow their blueprints, with no placeholders or wrong bodies; the two major issues are blueprint-side — a dangling `\lean{...}` pin for `coverDatum_bridge` (already noted in `% NOTE:`) and an undocumented scope overclaim in `lem:affine_injective_acyclic` that will block the `affineCoverSystem` build step.
