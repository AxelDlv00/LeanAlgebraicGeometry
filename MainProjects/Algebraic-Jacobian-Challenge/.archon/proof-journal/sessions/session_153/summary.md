# Session 153 (iter-153) — review summary

## Metadata

- **Iteration / session:** 153
- **Sorry count (declaration-level): 9 → 8** (NET −1; the first net
  sorry reduction since the pivot, validating the `[IsAlgClosed]` route).
- **Prover lanes:** 1 (`Cotangent/ChartAlgebra.lean`), `prover.status:
  done`, `durationSecs: 471` (~7.9 min).
- **Targets attempted:** `constants_integral_over_base_field` (PRIMARY,
  guaranteed collapse) + `KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero`
  (KDM, secondary, bright-lined) + comment hygiene.
- **Prover activity** (per `attempts_raw.jsonl`): 5 edits, 0 goal
  checks, 5 diagnostic checks, 0 builds, 7 lemma searches, 1 task report.

## Per-file sorry tally at iter-153 close (re-verified)

| File | sorry sites | line(s) |
|---|---|---|
| `Cotangent/ChartAlgebra.lean` | **1** (was 2) | 427 (KDM) |
| `Cotangent/ChartAlgebraS3.lean` | 4 (off-path) | 199, 276, 342, 403 |
| `Cotangent/GrpObj.lean` | 0 | — |
| `Jacobian.lean` | 2 | 197, 223 |
| `RigidityKbar.lean` | 1 | 88 |

Total: **8**.

## Target 1 — `constants_integral_over_base_field` — SOLVED ✅

The guaranteed-collapse lemma promised by the iter-152 `[IsAlgClosed k]`
pivot. Closed in ~25–30 LOC, **axiom-clean**: `lean_verify` returns
`{propext, Classical.choice, Quot.sound}` with **no `sorryAx`** (verified
this review on `AlgebraicGeometry.constants_integral_over_base_field`).

Final proof structure (three steps):

1. `set f := X ↘ Spec (CommRingCat.of k)`. Then
   `haveI : IrreducibleSpace X := GeometricallyIrreducible.irreducibleSpace_of_subsingleton f`
   (`Subsingleton (Spec (.of k))` resolves by `inferInstance`),
   `haveI : IsIntegral X := isIntegral_of_irreducibleSpace_of_isReduced X`,
   and `letI : Field Γ(X, ⊤) := (isField_of_universallyClosed k f).toField`
   (properness ⟹ `UniversallyClosed`+`LocallyOfFiniteType` auto-infer).
2. `let F := (Scheme.ΓSpecIso (.of k)).inv ≫ f.appTop`; finiteness of
   `F.hom` transferred across the iso via
   `RingHom.finite_respectsIso.2 (e := (ΓSpecIso _).symm.commRingCatIsoToRingEquiv)`
   applied to `finite_appTop_of_universallyClosed k f`; then
   `Module.Finite k Γ` and `Algebra.IsIntegral.of_finite k Γ`.
3. `IsAlgClosed.algebraMap_bijective_of_isIntegral` gives `algebraMap k Γ`
   (= `F.hom`) bijective; `rw [RingHom.range_eq_top]`; since
   `F.hom = f.appTop.hom.comp (ΓSpecIso).inv.hom` by `rfl`, surjectivity
   of `f.appTop.hom` follows from `Function.Surjective.of_comp`.

**Key reusable insight:** `RingHom.finite_respectsIso : RespectsIso @Finite`
(`RingTheory/RingHom/Finite.lean`); `.2` precomposes finiteness by a ring
iso — the exact analogue of the `isIntegral_respectsIso.2` step inside
Mathlib's own `isField_of_universallyClosed` proof. Transferring a
`Γ(Spec k, ⊤)`-side property to a `k`-side one across `ΓSpecIso` is a
recurring chart-algebra pattern.

## Target 2 — KDM `mem_range_algebraMap_of_D_eq_zero` — BLOCKED (Mathlib gap, bright-line) ⛔

No code change (search-only, per the PROGRESS.md objective-(b) bright-line).
The single residual content is blueprint step **FT.3**:

> For a separably generated field extension `K/k` (char 0, finitely
> generated), `ker (KaehlerDifferential.D k K : K → Ω[K⁄k])` equals the
> relative algebraic closure of `k` in `K` (the "field of constants").

Confirmed **ABSENT from Mathlib** (snapshot b80f227). Negative searches:

- loogle `KaehlerDifferential.D _ _ ?x = 0` → ∅ (no kernel-description lemma).
- `Differential.ContainConstants` / `mem_range_of_deriv_eq_zero`
  (`RingTheory/Derivation/DifferentialRing`) is for an **abstract single
  derivation `B → B`** (a `Differential B` instance), not the universal
  Kähler derivation; the only shipped instance is the trivial
  `ContainConstants A A`.
- `Algebra.FormallyUnramified.iff_isSeparable` + `Subsingleton Ω[L⁄K]`
  (`RingTheory/Unramified/Field`) only cover the **algebraic**
  (`EssFiniteType`) case `Ω = 0`; the function field `K = Frac B` has
  positive transcendence degree, so `Ω[K⁄k] ≠ 0` — does not apply where
  the content lives.
- `RingTheory/Smooth/Field` gives `FormallySmooth` for separably-generated
  extensions but exposes **no** basis of `Ω[K⁄k]` from a separating
  transcendence basis and **no** kernel description.

The bright-line was correctly honoured: the `sorry` was retained with the
full negative-search documentation inline (`ChartAlgebra.lean:400–426`),
**no new helper layer added**, no re-decomposition.

## Key findings / patterns

1. **The `[IsAlgClosed]` pivot is now prover-validated.** The first net
   sorry reduction since iter-148 (9→8) came directly from the corrected
   signature, exactly as the iter-152 plan predicted (guaranteed collapse).
   The progress-critic's standing must-fix ("a prover MUST validate the
   corrected signatures by iter-154") is **discharged this iter**.
2. **Chart-algebra iso-transfer pattern** (reusable): transfer a
   `Γ(Spec k)`-side ring-hom property to the `k`-side via
   `XYZ_respectsIso.2 (e := (ΓSpecIso _).symm.commRingCatIsoToRingEquiv)`,
   then recover the original `appTop.hom` surjectivity by
   `Function.Surjective.of_comp` on `F.hom = appTop.hom.comp (ΓSpecIso).inv.hom`
   (which holds by `rfl`).
3. **KDM is a genuine research-grade Mathlib gap, not a tactic miss.** The
   bright-line correctly stopped after one search round. The next move is
   a `mathlib-analogist` cross-domain consult, NOT another prover round.

## Blueprint markers updated (manual)

- None. `constants_integral_over_base_field`'s proof block already carried
  `\leanok` (the deterministic `sync_leanok` confirms it now that the proof
  is closed and axiom-clean); the closure is a project proof, not a Mathlib
  re-export, so no `\mathlibok`. The KDM block correctly retains no
  `\leanok` on its proof (open `sorry`). No `\lean{...}` rename occurred; no
  stale `\notready` to strip.

## Subagent reports

- `lean-auditor-iter153.md` — **0 must-fix / 6 major / 6 minor**. Confirms
  the closure is `sorryAx`-free and KDM is the file's only open sorry. All
  majors are post-pivot hygiene/orphaning (notably `ChartAlgebraS3.lean` now
  entirely orphaned; KDM body's inert scaffolding + conflicting route
  narratives; `df_zero` sorryAx-launder; stale Jacobian header inventory).
  Findings folded into `recommendations.md` §2–§3.
- `lean-vs-blueprint-checker-chartalgebra-iter153.md` — **PASS** (0 must-fix /
  0 major). Both directive lemmas match `RigidityKbar.tex` bidirectionally;
  closure verified axiom-clean; KDM's open FT.3 reflected correctly. 2 minor
  housekeeping items in `recommendations.md` §5.

## Recommendations for next session

See `recommendations.md`. Headline: KDM → `mathlib-analogist` cross-domain
consult before any further KDM prover round; re-assess the Route C
trajectory now that there is genuine post-pivot prover data.
