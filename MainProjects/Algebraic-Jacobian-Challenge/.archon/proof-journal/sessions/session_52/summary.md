# Session 52 — iter-052 review

## Metadata

- **Archon iteration**: 052
- **Stage**: prover (Phase A step 6 *Path 2* / Serre-finiteness scaffolding — **generalised rewrite-bridge `⨆𝒰 = U` for HModule' consumer + curve specialisation**)
- **File touched**: `AlgebraicJacobian/Cohomology/MayerVietoris.lean` (single file, single combined Edit)
- **Sorry count before**: 9 (5 `Jacobian.lean` + 3 `AbelJacobi.lean` + 1 deferred `Picard/Functor.lean`)
- **Sorry count after**: 9 (unchanged — bodies probe-confirmed; no transient scaffold sorries)
- **LOC delta on touched file**: 1213 → 1264 (+51). Plan-agent prompt forecast `+30–50` ("within +30-50 plan band"); iter-052 came in at +51, **just one over the band**. The slight overshoot is consistent with the plan, since iter-052 introduces a new degree of generality (`⨆𝒰 = U` rewrite-bridge) over iter-051's `(⨆𝒰)`-direct form. Note: the prompt header records "1165 → 1213 (+48)" which is the iter-051 closure baseline (i.e. iter-051's own delta) — the iter-052 delta is +51 on top of that.
- **Attempts (raw events from `attempts_raw.jsonl`)**: **1 substantive Edit** (single combined append of both new declarations), 1 diagnostic check (clean), 2 axiom verifications (kernel-only on both new declarations, plus the prover task result also reports them), 0 builds, 0 lemma searches, **0 corrective Edits — sixth zero-corrective single-Edit iteration in a row** (iter-047 → iter-048 → iter-049 → iter-050 → iter-051 → iter-052).
- **Net diagnostics (review-side re-verification this pass)**: clean — `lean_diagnostic_messages` returns `{success: true, items: [], failed_dependencies: []}` (no errors).
- **Axioms (this pass)**: kernel-only `[propext, Classical.choice, Quot.sound]` on both new declarations, verified via `lean_verify` directly this review pass. No new axiom introduced (`Classical.choice` was already in scope since iter-048).

## Targets attempted (two solved, one combined Edit)

The plan: append two declarations to `Cohomology/MayerVietoris.lean` `section CoverTotality` (inside `namespace AlgebraicGeometry.Scheme`), after iter-051's `subsingleton_HModule'_supr_of_hasCechToHModuleIso_curve` (L1201) and before the closing `end CoverTotality`. The cohort is the **generalised rewrite-bridge `⨆𝒰 = U`** counterpart to iter-051's `(⨆𝒰)`-direct form: under both class hypotheses plus an equality hypothesis `h : ⨆ i, 𝒰 i = U`, conclude `Subsingleton (HModule' k F n U)` for arbitrary open `U` — the exact form iter-054+ will consume to instantiate `IsAffineHModuleVanishing k C (toModuleKSheaf C)` for an affine open via a basic-open cover (where the equality holds by construction).

### Target 1 — `AlgebraicGeometry.Scheme.subsingleton_HModule'_of_hasCechToHModuleIso` (L1231)

`theorem`. Generalised rewrite-bridge from iter-051's `(⨆𝒰)`-form to an arbitrary open `U` under equality hypothesis.

#### Attempt 1 (success — first attempt, single combined Edit)
- **Strategy**: Verbatim probe-confirmed body from PROGRESS.md template. Apply iter-051 to obtain `Subsingleton (HModule' k F n (⨆ i, 𝒰 i))`, then rewrite via `h ▸ this` to land on `U`.
- **Code applied** (signature + body, L1231–L1241):
  ```lean
  theorem subsingleton_HModule'_of_hasCechToHModuleIso
      {k : Type u} [Field k] {C : Over (Spec (.of k))}
      {F : Sheaf (Opens.grothendieckTopology C.left.toTopCat) (ModuleCat.{u} k)}
      {ι : Type u} {𝒰 : ι → TopologicalSpace.Opens C.left.toTopCat}
      [HasExt.{u} (Sheaf (Opens.grothendieckTopology C.left.toTopCat) (ModuleCat.{u} k))]
      [IsCechAcyclicCover F 𝒰] [HasCechToHModuleIso F 𝒰]
      {U : TopologicalSpace.Opens C.left.toTopCat}
      (h : ⨆ i, 𝒰 i = U) (n : ℕ) (hn : 0 < n) :
      Subsingleton (HModule' k F n U) := by
    haveI := subsingleton_HModule'_supr_of_hasCechToHModuleIso (F := F) (𝒰 := 𝒰) n hn
    exact h ▸ this
  ```
- **Result**: kernel-only axioms `[propext, Classical.choice, Quot.sound]` (verified via `lean_verify` this review pass).
- **Insight**: This is the universe-`u` `HModule'` parallel to iter-049's `(h : ⨆𝒰 = ⊤)`-style rewrite at universe `u+1` for `HModule`. The `h ▸ this` rewrite is load-bearing — without it, `Subsingleton (HModule' k F n U)` does not unify with iter-051's conclusion `Subsingleton (HModule' k F n (⨆ i, 𝒰 i))`. The `(F := F) (𝒰 := 𝒰)` named-argument syntax is needed because iter-051's signature has implicit `{F}` and `{𝒰}` arguments, so positional inference is ambiguous. Stays single-universe `[HasExt.{u}]` (no iter-034 universe bridge needed) — confirms iter-051's design choice was correctly forward-compatible with this generalisation.

### Target 2 — `AlgebraicGeometry.Scheme.subsingleton_HModule'_of_hasCechToHModuleIso_curve` (L1251)

`theorem` (term-mode forwarding). Curve specialisation at `F := Scheme.toModuleKSheaf C`.

#### Attempt 1 (success — first attempt, same Edit as Target 1)
- **Strategy**: Verbatim probe-confirmed body. Direct application of Target 1 with `F := toModuleKSheaf C`, named-argument syntax `(𝒰 := 𝒰)` to lock in the cover.
- **Code applied** (body, L1260):
  ```lean
  subsingleton_HModule'_of_hasCechToHModuleIso (𝒰 := 𝒰) h n hn
  ```
- **Result**: kernel-only axioms `[propext, Classical.choice, Quot.sound]` (verified via `lean_verify` this review pass).
- **Insight**: Mirrors the iter-039 / iter-042 / iter-043 / iter-048 / iter-049 / iter-050 / iter-051 `_curve` pattern. The `h` argument is forwarded directly. This is the exact `Subsingleton`-form iter-054+ needs to instantiate `IsAffineHModuleVanishing` for an affine open `U` via a basic-open cover `𝒰` of `U`.

## Key findings / proof patterns

- **Rewrite-bridge generalisation pattern** *(iter-052, parallels iter-049's `_top` rewrite at universe `u+1`)*: when an instance-driven consumer lands `Subsingleton X(⨆𝒰)` on the lattice supremum, the natural generalisation is to add an equality hypothesis `h : ⨆𝒰 = U` and conclude `Subsingleton X(U)`. The body is a thin `haveI := <the consumer>; exact h ▸ this` two-line tactic block. Reusable wherever an open `U` needs to be presented as a sup of a cover but the consumer chain expects `(⨆𝒰)`-direct form.
- **Symmetry between universe-`u` `HModule'` rewrite-bridge (iter-052) and universe-`u+1` `HModule` rewrite-bridge (iter-049)** *(iter-052, new this iteration)*: iter-049 closed the `(h : ⨆𝒰 = ⊤)` form at universe `u+1` via universe transport; iter-052 closes the more general `(h : ⨆𝒰 = U)` form at universe `u` without crossing the universe boundary. Both share the same `h ▸ this` rewrite step but differ in (a) target universe, (b) whether the rewrite is to `⊤` or arbitrary `U`, and (c) whether an additional iter-034 universal bridge intervenes. Iter-054+ producer for affine `IsAffineHModuleVanishing` consumes iter-052 (universe `u`, arbitrary `U`).
- **Implicit-argument disambiguation via `(F := F) (𝒰 := 𝒰)` named args** *(iter-052, generalises iter-049 / iter-050 / iter-051 `(𝒰 := 𝒰)`-only pattern)*: when a chained call to an iter-N consumer has both `{F}` and `{𝒰}` implicit, positional inference is ambiguous if any subsequent argument matches multiple types. Named-argument syntax `(F := F) (𝒰 := 𝒰)` is the canonical disambiguator. Generalises iter-049 / iter-050 / iter-051's `(𝒰 := 𝒰)`-only pattern (which sufficed when `F` was nailed down by class instances).
- **Verbatim probe-confirmed body, single combined Edit pattern continues** *(iter-035 → iter-052)*: 15 of 18 iterations zero-corrective-Edit, 1 with cosmetic corrective (iter-044), 1 with cosmetic corrective (iter-046). **Iter-052 = sixth zero-corrective Edit in a row** (iter-047 → iter-048 → iter-049 → iter-050 → iter-051 → iter-052). Pattern firmly established and now scaling cleanly across two consecutive double-declaration `MayerVietoris.lean` rewrite-bridge cohorts (iter-051 → iter-052).
- **LOC band consistency** *(iter-052, slight 1-LOC over)*: iter-052 came in at +51 vs the `+30–50` plan band — a 1-line overshoot. Within tolerance; reflects the slightly heavier docstring on `subsingleton_HModule'_of_hasCechToHModuleIso` (which introduces a new generalisation degree) compared to iter-051's pure secondary-symmetry counterparts. Plan-agent should keep the widened `+50–80` (or `+50–100` for the heaviest) LOC band for iter-053+ iterations introducing substantive new content.

## Blueprint markers updated

The iter-052 plan-agent **continued the blueprint-subsection / `\leanok`-pre-mark discipline** restored in iter-051. The plan-agent authored:

1. **The iter-052 subsection** at L1159–L1187 of `Cohomology_MayerVietoris.tex` (`\subsection{Generalised rewrite-bridge $\bigsqcup\mathcal U = U$ for HModule' (iter-052)}` with two `\begin{theorem}` blocks and `\leanok` markers on both statements + both proofs). Labels `thm:Scheme_subsingleton_HModule_prime_of_hasCechToHModuleIso` and `thm:Scheme_subsingleton_HModule_prime_of_hasCechToHModuleIso_curve`. The `\uses{...}` cross-references resolve correctly.
2. **An informal scoping subsection** at L1189 (`\subsection{Toward the iter-053+ comparison theorem (informal scoping)}`) — moved one step forward from iter-051's L1159 placement; updated content reflects the iter-052 closure.
3. The retrospective paragraph at L1209 was extended to reference both iter-052 labels — `\ref{thm:Scheme_subsingleton_HModule_prime_of_hasCechToHModuleIso}` and `\ref{thm:Scheme_subsingleton_HModule_prime_of_hasCechToHModuleIso_curve}` — now resolving correctly.
4. **`blueprint/lean_decls`** caught up with 2 new entries at L101–L102 (`subsingleton_HModule'_of_hasCechToHModuleIso` and `_curve`). **Thirteenth clear-as-you-go iteration in a row** for `lean_decls` (iter-040 → iter-052).

This review-side pass:
- Re-verified both iter-052 declarations exist at the names referenced by `\lean{...}` (✓), the file compiles cleanly (`lean_diagnostic_messages` returns `{success: true, items: [], failed_dependencies: []}`), and both declarations carry kernel-only axioms `[propext, Classical.choice, Quot.sound]` (verified via `lean_verify`).
- No new marker changes from the review side this pass — the plan-agent's pre-marks are all valid.

### Marker change record

- `Cohomology_MayerVietoris.tex`, **iter-052 subsection** (newly authored by the plan-agent this iteration at L1159–L1187): pre-marks validated. `thm:Scheme_subsingleton_HModule_prime_of_hasCechToHModuleIso` `\leanok` on statement (L1163) + proof (L1172); `thm:Scheme_subsingleton_HModule_prime_of_hasCechToHModuleIso_curve` `\leanok` on statement (L1176) + proof (L1185). **Both iter-052 declarations correspondingly compile, `sorry`-free, with kernel-only axioms (verified this pass).**
- `Cohomology_MayerVietoris.tex`, **iter-051 retrospective paragraph** (now at L1209): extended to reference both iter-052 labels — both labels resolving correctly.
- No `% NOTE:` comments remain in any chapter (verified absent).
- No `\notready` markers remain in any chapter (verified absent).

## Recommendations for next session (iter-053)

See `recommendations.md`. The generalised rewrite-bridge HModule' consumer + curve specialisation are now in place at universe `u`; combined with iter-049 / iter-050's `_top` consumers at universe `u+1` and iter-051's `(⨆𝒰)`-direct consumers at universe `u`, the entire instance-driven Cover-totality consumer surface (top + intermediate-supremum + arbitrary `U` via rewrite) is closed. Highest-priority track for iter-053: **the substantive Čech-vs-derived comparison theorem** (the data argument that gets wrapped via `⟨⟨the_iso⟩⟩` into a `HasCechToHModuleIso` instance), now revised down from a 4-6-iteration cohort to a ~3-4-iteration cohort given the iter-052 thin-scaffolding closure (Phase A iterations-remaining revised DOWN from ~5 to ~4 per the prompt header).
