# Recommendations for the next plan-agent iteration (iter-113)

## Must-fix-this-iter (from review subagents)

### From `lean-vs-blueprint-checker-differentials-iter112`

**Signature mismatch — must-fix-this-iter — three pre-existing issues now formally flagged.** The blueprint chapter prose and the Lean signatures have diverged in three places in `AlgebraicJacobian/Differentials.lean`. These are not iter-112-introduced; they have been latent. The reviewer's bidirectional pass surfaces them. The iter-113 plan agent should dispatch a **refactor lane** (NOT a prover lane) to align the Lean signatures with the blueprint:

1. **`smooth_iff_locally_free_omega` (L816)** — blueprint pins "smooth **of relative dimension n**" via `AlgebraicGeometry.IsSmoothOfRelativeDimension n f`, but Lean uses dimension-free `Smooth f` plus a free standalone `n : ℕ`. The biconditional `Smooth f ↔ (locally rank n)` for free `n` is not satisfiable (different choices of `n` give logically equivalent LHS but inequivalent RHS). **Fix**: replace `Smooth f` with `IsSmoothOfRelativeDimension n f` and drop the standalone `(n : ℕ)` parameter; `n` then comes from the hypothesis. (Protected? No — verified `archon-protected.yaml` does not list this declaration, so it can be re-signed by a refactor lane.)

2. **`cotangent_at_section` (L832)** — identical signature mismatch (corollary of L816). Same fix.

3. **`serre_duality_genus` (L976)** — Lean writes both sides as `HModule k _ 0` (i.e. `H^0 = H^0`); blueprint asserts `dim_k H^0(C, Ω_{C/k}) = dim_k H^1(C, O_C)`. **The Lean equation as currently written is mathematically false for genus > 1.** The local docstring at L971–975 in fact agrees with the blueprint (mentions H^0 vs H^1), so the docstring is internally inconsistent with the signature. **Fix**: bump the second-index `0` to `1`, and pair the correct sheaf with each index. Also tighten: blueprint says "geometrically irreducible curve" (Lean has only `IsIntegral`); add `geometrically` upgrade and the dimension-1 hypothesis. Until fixed, this declaration cannot receive a proof body — it would be proving a false equation.

These three signature fixes are **prerequisite to any future prover lane on Phase B's L735 / L718 / L877 (now L823/L840/L982 after iter-112's renumber)**. Without the fixes, a prover would either (a) refuse to attempt the false equation, or (b) attempt it and fail in a way that wastes an iter.

The reviewer also recommends `% NOTE:` annotations on the corresponding blueprint blocks; the review agent applied those this iter (see `summary.md` § "Blueprint markers updated").

Report: `.archon/task_results/lean-vs-blueprint-checker-differentials-iter112.md`.

### From `lean-auditor-iter112`

**No new must-fix.** Three carry-over majors from iter-109 (Differentials.lean L27–30 header rot, BasicOpenCech.lean L1715/L1752 cross-iter excuse-comments) and 4 minors (1 new: Differentials.lean L213–215 inline "Project-level sorry total: 5" claim contradicting L146 "file-level" phrasing; 3 stale-label). None block downstream work. A refactor lane on `Differentials.lean` header rot would be cheap upkeep but is not urgent. Report: `.archon/task_results/lean-auditor-iter112.md`.

## Closest to completion — prioritize next iter

### Primary target: `relativeDifferentialsPresheaf_isSheafOpensLeCover_type` (L159 of Differentials.lean)

This is the single remaining `sorry` introduced by iter-112's Bar B scaffolding. Closing it advances **Bar A** (file sorry count 5 → 4; project total 16 → 15).

**Concrete recipe** (from the iter-112 prover task result):

#### Sub-lemma A — affine restriction to tilde sheaf identification (~40–80 LOC)
For an affine open `V = Spec B ⊆ X` over an affine `Spec A ⊆ S`, the restriction of the underlying type-valued presheaf of `relativeDifferentialsPresheaf f` to opens contained in `V` is naturally isomorphic, as a presheaf of types on `Opens V`, to the underlying type-valued presheaf of `AlgebraicGeometry.tilde Ω_{B/A}` (viewed on `Opens V` via the affine isomorphism `V ≅ Spec B`).

Key inputs (all verified `[verified]` this iter):
- `KaehlerDifferential.isLocalizedModule_map` (Mathlib.RingTheory.Etale.Kaehler) — gives the localisation iso `Ω_{B/A} ⊗_B B[1/g] ≅ Ω_{B[1/g]/A}`.
- `AlgebraicGeometry.IsAffineOpen.isLocalization_basicOpen` (Mathlib.AlgebraicGeometry.AffineScheme) — gives `Γ(D(g), 𝒪_X) ≅ B[1/g]`.
- `AlgebraicGeometry.tilde` (Mathlib.AlgebraicGeometry.Modules.Tilde) — the carrier. **Namespace correction (still load-bearing)**: the blueprint writes `AlgebraicGeometry.Modules.tilde`, but Mathlib's actual name is `AlgebraicGeometry.tilde`. Use the latter.

#### Sub-lemma B — sheaf-on-affine-basis ⇒ sheaf-on-all-opens (~50–100 LOC)
For an arbitrary family `U : ι → Opens X.toTopCat`, refine through `AlgebraicGeometry.Scheme.isBasis_affineOpens` to a refined cover whose elements each lie in an affine chart; on each affine chart, Sub-lemma A supplies the equalizer condition; cofinality refinement in the `OpensLeCover` category lifts back.

Key input: `AlgebraicGeometry.Scheme.isBasis_affineOpens` (verified) + the limit-preservation under cofinal-refinement of cocones in `OpensLeCover` (no off-the-shelf lemma; the [gap] flag in the chapter at L50 explicitly anticipates this).

#### Composition
Helper #1's body becomes `intro ι U; exact (sub-lemma B applied to sub-lemma A on each affine restriction) f U`. Combined ~100–200 LOC matches the iter-111 plan-agent's revised LOC budget.

**Risk**: Sub-lemma B is non-trivial — no Mathlib `TopCat.SheafOnBasis` framework for `Scheme.PresheafOfModules`. The blueprint chapter's `[gap]` at L50 explicitly anticipates hand-construction. If iter-113 hits unrecoverable elaboration friction on Sub-lemma B, fall back to Route (b) (explicit affine-cover gluing) — but record the pivot in the prover report.

### Secondary: refactor lane on the 3 signature mismatches (above)

Before resuming Phase B on L735/L718/L877, fix the three signature mismatches via a refactor lane. The refactor:
- replaces `Smooth f` with `IsSmoothOfRelativeDimension n f` in `smooth_iff_locally_free_omega` (L816) and `cotangent_at_section` (L832);
- fixes the `H^0 = H^0` equation to `H^0 = H^1` in `serre_duality_genus` (L976), bumping one index and pairing with the correct sheaf;
- adds `geometrically irreducible` and dimension-1 hypotheses to `serre_duality_genus`.

None of these three declarations are listed in `archon-protected.yaml` (verified). All three currently have `sorry` bodies, so the refactor only changes statements + re-inserts `sorry`. Project sorry count unchanged.

## Approaches that showed promise but need more work

- **The Bar-B scaffolding pattern** (one load-bearing helper + one derived helper + closed main theorem) is reusable when a multi-step proof has a load-bearing single sub-claim. The key invariant: **expose the load-bearing sub-claim with the *characterisation namespace* in its signature** (here `TopCat.Presheaf.IsSheafOpensLeCover`, not `Presheaf.IsSheaf` after Step 1), so that the bridging characterisation (here `isSheaf_iff_isSheafOpensLeCover`) fires inside the derived helper's body cleanly. Avoids the "second-rw on the post-rw goal fails because of namespace alias" trap.

## Blocked targets — DO NOT ASSIGN

- **`Modules/Monoidal.lean:L173 instIsMonoidal_W`** — named Mathlib gap. Off-limits.
- **`Picard/LineBundle.lean:L82 pullback_tensorObj` + `L96 pullback_oneIso`** — named Mathlib-gap pair (μIso + εIso of the missing `Functor.Monoidal (Scheme.Modules.pullback f)`). Off-limits.
- **`Differentials.lean:L622 cotangentExactSeq_structure h_exact`** — named gap #2, deferred parallel to `instIsMonoidal_W`. Off-limits.
- **`Differentials.lean:L976 serre_duality_genus`** — named gap #7. **Plus**: signature is currently mathematically false (see must-fix above). Refactor before any prover lane.
- **`Jacobian.lean:L179 nonempty_jacobianWitness`** — Phase C3 exit policy. Off-limits.
- **`Picard/Functor.lean:L181 representable`** — gated on Phase C3. Off-limits.
- **`Cohomology/BasicOpenCech.lean` all 6 sorries (L1120 PAUSED, L1212/L1536/L1564 substep-deferred, L1754 gated on L1120, L1846 budget-deferred)** — Phase A STUCK-deferred. Off-limits.

## Anti-patterns observed (do not retry)

- **`rw [TopCat.Presheaf.isSheaf_iff_isSheaf_comp ...]` to reduce `Presheaf.IsSheaf (Opens.grothendieckTopology X.toTopCat) ...`** — wrong namespace path; the alias-rewrite fails to match the raw `CategoryTheory.Presheaf.IsSheaf` shape. Use `Presheaf.isSheaf_iff_isSheaf_comp _ _ (CategoryTheory.forget _)` (bare namespace, with two metavariable placeholders + explicit forgetful).
- **`forget AddCommGrpCat` without `CategoryTheory.` prefix** — parses as `AlgebraicGeometry.Scheme.forget` under the file's `open AlgebraicGeometry` + `namespace AlgebraicGeometry.Scheme`. Always qualify.
- **Field-access `(F ⋙ forget _).IsSheafOpensLeCover`** — `IsSheafOpensLeCover` is not a `Functor` field; it is a standalone declaration under `TopCat.Presheaf`. Use the qualified form `TopCat.Presheaf.IsSheafOpensLeCover (F ⋙ forget _)` in lemma signatures.
- **Inline `mpr by intro ι U; sorry` packaging** to chain Step 1 reduction + Step 3 characterisation in a single proof block — the post-Step-1 goal-shape doesn't match the OpensLeCover characterisation directly; packaging via a separately-named helper with the characterisation namespace in its conclusion is the right approach (the v3 pattern).
- **Two identical-signature helpers in a Bar-B scaffold** (v1 anti-pattern) — pure boilerplate, indistinguishable mathematically. **Two distinct-signature helpers each with a sorry body** (v2 anti-pattern) — regresses sorry count. The right shape is one load-bearing helper + one derived helper (v3).

## Reusable proof patterns discovered (recap from summary.md)

1. **Bar-B scaffolding for multi-step proofs**: one load-bearing helper with the characterisation namespace in its conclusion + one fully-closed derived helper bridging back to the original goal-shape + a fully-closed main body performing the leading reduction and delegating to the derived helper. Documented at `Differentials.lean:98–227`.
2. **`Presheaf.isSheaf_iff_isSheaf_comp _ _ (CategoryTheory.forget AddCommGrpCat)` for Ab → Type forgetful reduction in the `Opens.grothendieckTopology X` setting**. Documented at `Differentials.lean:225`.
3. **`TopCat.Presheaf.IsSheafOpensLeCover (...)` as qualified standalone (NOT field-access)**. Documented at `Differentials.lean:160`.

These patterns extend the project's reusable-pattern catalogue (Knowledge Base).
