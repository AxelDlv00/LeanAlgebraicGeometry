# Session 32 (iter-032) — summary

## Metadata
- **Iteration**: 032. **Session**: session_32. Model: claude-opus-4-8.
- **Project sorry**: 2 → 2 (no regression). Both frozen/superseded: `CechHigherDirectImage.lean:679`
  (frozen P5b target) + `CechAcyclic.lean:110` (dead superseded `affine`). Both prover files 0-sorry.
- **Lanes planned 2, ran 2** (both `mathlib-build`, "build as far as possible"). **+8 axiom-clean decls**
  (Lane A +1, Lane B +7). 0 new sorries.
- **Build**: GREEN. Both files `lake env lean … EXIT 0`, diagnostic-clean; `lean_verify` axiom-clean
  `{propext, Classical.choice, Quot.sound}` for the named targets.
- `archon dag-query`: **gaps = 0** (the iter-031 `tilde_preserves_kernels` gap was given an informal proof in
  the plan phase), **unmatched = 8** (1 pre-existing dead `CechAcyclic.affine` + 7 new `private` QcohTilde helpers).

## Targets

### Lane A — `AffineSerreVanishing.lean` (02KG affine cover-system): PARTIAL, stopped on real mathematics
**SOLVED: `standard_cover_cofinal`** (Tag 009L, step 2 of the cover-system plan), axiom-clean.
- Statement (realized): `(f : R) (W : α → (Spec R).Opens) (hcov : D(f) ≤ ⨆ a, W a) → ∃ n (g : Fin n → R)
  (φ : Fin n → α), D(f) = ⨆ i, D(g i) ∧ ∀ i, D(g i) ≤ W (φ i)` — the genuine finite-standard-subcover
  refinement (lean-auditor + lvb both confirmed faithful & non-vacuous).
- Proof: quasi-compactness of `D(f)` (`PrimeSpectrum.isCompact_basicOpen`) + basic-open basis
  (`isTopologicalBasis_basic_opens` + `IsTopologicalBasis.exists_subset_of_mem_open`) +
  `IsCompact.elim_finite_subcover`; index type `I := {p : R × α // B p.1 ≤ Uf ⊓ W p.2}` carries the witness,
  repackaged to `Fin t.card` via `Finset.equivFin`.
- **Key technique (reuse downstream)**: the `(Spec R).Opens` (carrier `↥(Spec R)`) vs `PrimeSpectrum R` defeq
  impedance. Coercing a *variable* `Uf : (Spec R).Opens` to `Set ↥(Spec R)` works; coercing an inline
  `(PrimeSpectrum.basicOpen r : (Spec R).Opens)` ascription does NOT insert the SetLike coercion. Bind to
  `Uf`/`B` via `set`/`let` first. Use `change` not `show` to avoid the show-tactic linter.

**BLOCKED: `toSheaf_preservesEpimorphisms`** (step 1, the load-bearing blocker for steps 3–4). NOT a quick
gap-fill — it is `toSheaf` RIGHT-exactness, i.e. `(SheafOfModules.toSheaf X.ringCatSheaf).PreservesFiniteColimits`,
which Mathlib does NOT package (ships only `PreservesFiniteLimits`, `Faithful`, `Additive`). Four elementary
routes attempted in Lean, all circular or dead:
1. `rw [← Sheaf.isLocallySurjective_iff_epi']` — needs `Balanced (Sheaf (Opens.grothendieckTopology X)
   AddCommGrpCat)` which fails to synthesize even with `backward.isDefEq.respectTransparency false` +
   `synthInstance.maxHeartbeats 4000000` + explicit `haveI`; and the content (`Epi g ⟹ IsLocallySurjective
   (toSheaf g)`) is exactly what's missing. (Easy direction `IsLocallySurjective → Epi` IS available via
   `Sheaf.epi_of_isLocallySurjective`.)
2. `Functor.preservesEpimorphisms_of_preserves_shortExact_right` — needs `(toSheaf).Additive` during `apply`,
   AND its hypothesis requires `Epi (toSheaf S.g)` = the goal (circular).
3. Stalk route — needs stalk-exactness of the `SheafOfModules` SES = same fact.
4. `toSheaf ≅ (forget ⋙ toPresheaf) ⋙ presheafToSheaf` — fails: `forget` (= `toPresheafOfModules`) is a RIGHT
   adjoint, does not preserve epis.
Prover reverted to a thorough in-file documentation block (no sorry). Precise next ingredient:
`(SheafOfModules.toSheaf R).PreservesFiniteColimits` via the sheafification adjunction.

**BLOCKED (consequent): `affine_surj_of_vanishing` / `affineCoverSystem`** — gated on the toSheaf gap-fill
(`surj_of_vanishing` field). All other `BasisCovSystem` inputs ready (`faces_mem`, `injective_cech_acyclicFam`,
`standard_cover_cofinal`, `ses_cech_h1`). Prover correctly declined to invent a risky statement.

### Lane B — `QcohTildeSections.lean` (01I8 Route-P, P1b): COMPLETE for the assigned objective
**SOLVED: `isLocalizedModule_of_span_cover`** (P1b named target) + 6–7 `private` helpers, all axiom-clean.
- Statement (lvb-confirmed exact match to `lem:isLocalizedModule_of_span_cover`): `g : M →ₗ[R] N`, `f : R`,
  `s : Fin n → R` with `Ideal.span (Set.range s) = ⊤`, per-`j` hypothesis `IsLocalizedModule (powers f)` of
  `IsLocalizedModule.map (powers (s j)) (mkLinearMap..) (mkLinearMap..) g`, conclusion
  `IsLocalizedModule (powers f) g`.
- Proof: direct descent of all three `IsLocalizedModule` clauses (partition-of-unity):
  - `map_units` → reduce `IsUnit (algebraMap R (End R N) f^k)` to `f` via `Module.End.isUnit_iff` +
    Mathlib's `bijective_of_localized_span`; per-`r` localised map identified with mult-by-`f` via
    `map_smul_endFun`.
  - `surj` → `per_j_surj` extracts `(s j)^a • f^k • y = g m`; bump `a,k` to uniform `A,K` via `bump_eq`;
    conclude `f^K • y = g m` via `mem_range_of_span_pow`.
  - `exists_of_eq` → `per_j_eq` extracts `(s j)^a • f^k • z = 0`; bump and conclude via `eq_zero_of_span_pow`.
- New import: `Mathlib.RingTheory.LocalProperties.Exactness` (for `bijective_of_localized_span`).
- **P1a / P1 not attempted** (explicit planner directive; genuinely blocked on `SheafOfModules`-restriction-to-`D(f)`
  machinery absent from Mathlib).

## Subagent reviews (full reports in logs/iter-032/)
- **lean-auditor `iter032`**: both files clean, axiom-clean. 0 critical / 0 major / **1 minor** (AffineSerreVanishing
  line ~135: the `∧` visually appears inside the `⨆ i, …` body; Lean parses it correctly but explicit parens
  would remove a readability trap). No must-fix.
- **lvb `affine-iter032`**: 4 formalized decls faithful; `standard_cover_cofinal` signature correct.
  **1 must-fix-this-iter (blueprint-side)**: `lem:to_sheaf_preserves_epi` *rendered* proof prose asserts
  exactness from "`toSheaf` being a left adjoint" (WRONG direction) and omits that Mathlib lacks
  `PreservesFiniteColimits` — a prover following the prose is sent on a false path. **2 major**: stale `\uses`
  on `lem:standard_cover_cofinal` (statement-level lists `lem:scheme_isBasis_affineOpens` — unused, proof uses
  `isTopologicalBasis_basic_opens`; proof-level lists `lem:affine_faces_mem` — never called). See recommendations.
- **lvb `qcohtilde-iter032`**: CLEAN, 0 findings; chapter adequate, signature exact, helpers genuine.

## Key findings / patterns
- First-class confirmation that **iter-032 stopped on genuine mathematics, cleanly** (no sorry, no weakening):
  Lane B fully completed its objective; Lane A landed step 2 and stopped on the one named, real gap
  (`toSheaf` right-exactness).
- The `toSheaf_preservesEpimorphisms` blocker is now **fully characterised** and must not be re-dispatched as a
  one-shot gap-fill — see recommendations.
- Reusable proof patterns added to PROJECT_STATUS Knowledge Base: (Spec R).Opens defeq impedance handling;
  IsLocalizedModule span-cover descent recipe.

## Blueprint markers updated (manual)
- `Cohomology_CechHigherDirectImage.tex`, `lem:to_sheaf_preserves_epi`: added `% NOTE:` (NOT YET FORMALIZED;
  reduces to `PreservesFiniteColimits` absent from Mathlib; 4 routes circular/dead; real next ingredient named).
- `Cohomology_CechHigherDirectImage.tex`, `lem:qcoh_localized_sections`: updated the decomposition `% NOTE`
  P1b line from "dispatch-ready" → "DONE iter-032, axiom-clean; residual gate is now P1a".
- No `\leanok` touched (sync_leanok ran for iter 32: +4, sha dac28d1). No `\mathlibok` (no new Mathlib re-exports).
  No `\lean{...}` renames (prover used planned names). No stale `\notready` to strip.

## Recommendations
See `recommendations.md`. Headline: (1) blueprint-writer must REWRITE the `lem:to_sheaf_preserves_epi` rendered
proof prose (must-fix) and fix the stale `\uses` on `lem:standard_cover_cofinal`; (2) do not re-dispatch
`toSheaf_preservesEpimorphisms` as a quick fix — scope a dedicated `PreservesFiniteColimits` lane;
(3) 7 unmatched private helpers to bundle into the P1b block's `\lean{}`.
