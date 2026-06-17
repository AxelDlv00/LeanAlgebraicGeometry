# Session 48 — iter-048 review

## Metadata

- **Archon iteration**: 048
- **Stage**: prover (Phase A step 6 *Path 2* / Serre-finiteness scaffolding — **Čech-side acyclicity carrier predicate**)
- **File touched**: `AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean` (single file)
- **Sorry count before**: 9 (project-wide, non-archon: 5 in `Jacobian.lean` + 3 in `AbelJacobi.lean` + 1 deferred in `Picard/Functor.lean`)
- **Sorry count after**: 9 (unchanged — all three iter-048 bodies probe-confirmed and landed clean; no transient scaffold sorries)
- **LOC delta on touched file**: 865 → 931 (+66). Plan-agent prompt forecast `+30–50`; the overage matches the prover's task-result statement (multi-paragraph docstrings copied verbatim from PROGRESS.md).
- **Attempts (raw events from `attempts_raw.jsonl`)**: **1 substantive Edit** (single combined append of all three declarations), 1 diagnostic check (clean), 3 axiom verifications (kernel-only on all three), 0 builds, 0 lemma searches, 0 corrective Edits — **second zero-corrective single-Edit iteration in a row** (iter-047 → iter-048).
- **Net diagnostics (review-side re-verification this pass)**: clean — `lean_diagnostic_messages` returns `{success: true, items: [], failed_dependencies: []}`.
- **Axioms (review-side re-verification this pass)**: kernel-only `[propext, Classical.choice, Quot.sound]` on all three new declarations.

## Targets attempted (three solved, one Edit)

The plan: append three declarations to `Cohomology/StructureSheafModuleK.lean` between iter-047's `cechCohomology_OC_eq` (L858, ending L863) and the closing `end AlgebraicGeometry`. The cohort packages a Čech-side acyclicity carrier `class IsCechAcyclicCover`, an abstract consumer that takes the Čech-vs-derived comparison iso as an *explicit* argument (decoupling iter-048 from the substantive iter-049+ comparison), and the curve specialisation at `F := Scheme.toModuleKSheaf C`. All three landed in a single combined Edit, zero corrective.

### Target 1 — `AlgebraicGeometry.Scheme.IsCechAcyclicCover` (L876)

`class … : Prop`. Single-field carrier predicate: `subsingleton_cechCohomology : ∀ (n : ℕ), 0 < n → Subsingleton (Scheme.cechCohomology C F 𝒰 n)`.

#### Attempt 1 (success — first attempt, single combined Edit)
- **Strategy**: Verbatim probe-confirmed body from PROGRESS.md (`{success: true, diagnostics: []}` per the iter-048 prompt). Mirrors the iter-040 / iter-043 carrier-predicate pattern: a single-field `Prop` class capturing a combinatorial vanishing condition that downstream consumers receive as an instance argument.
- **Code applied**: see L876–L881.
- **Result**: lands kernel-only `[propext, Classical.choice, Quot.sound]`.
- **Insight**: `Subsingleton` over `IsZero` chosen for chainability with iter-040's `IsAffineHModuleVanishing` and downstream `Module.Finite` synthesis path. The `cechCohomology` lives in `ModuleCat.{u} k` but `Subsingleton` on the underlying type works cleanly.

### Target 2 — `AlgebraicGeometry.Scheme.subsingleton_HModule'_supr_of_isCechAcyclicCover` (L899)

`theorem`. Abstract consumer that, given `[IsCechAcyclicCover F 𝒰]` and an explicit comparison iso `compIso : ∀ n, cechCohomology C F 𝒰 n ≃ₗ[k] HModule' k F n (⨆ᵢ 𝒰 i)`, transports `Subsingleton` from `cechCohomology` to `HModule'`.

#### Attempt 1 (success — first attempt, same Edit as Target 1)
- **Strategy**: Verbatim probe-confirmed body. Body is two lines: `haveI` extracts the class field via named-argument syntax `(F := F) (𝒰 := 𝒰)`, then transport along `(compIso n).symm.toEquiv.subsingleton`.
- **Code applied**:
  ```
  haveI := Scheme.IsCechAcyclicCover.subsingleton_cechCohomology
    (F := F) (𝒰 := 𝒰) n hn
  exact (compIso n).symm.toEquiv.subsingleton
  ```
  see L899–L911.
- **Result**: kernel-only axioms verified.
- **Insight**: The decision to take `compIso` as an *explicit argument* rather than a class field (a) avoids forcing data into a `Prop`-valued class (which is forbidden — `LinearEquiv` is data) and (b) decouples Čech-side combinatorial vanishing from the substantive iter-049+ comparison theorem. Iter-049+ will provide the comparison theorem; iter-048's consumer accepts it directly via this argument.

### Target 3 — `AlgebraicGeometry.Scheme.subsingleton_HModule'_supr_of_isCechAcyclicCover_curve` (L920)

`theorem`. Curve specialisation at `F := Scheme.toModuleKSheaf C`. Term-mode dot-notation reuse of Target 2 with `F` instantiated.

#### Attempt 1 (success — first attempt, same Edit as Target 1)
- **Strategy**: Verbatim probe-confirmed body. Direct application of Target 2 at `F := Scheme.toModuleKSheaf C`, named-argument syntax `(𝒰 := 𝒰)`.
- **Code applied**:
  ```
  Scheme.subsingleton_HModule'_supr_of_isCechAcyclicCover (𝒰 := 𝒰) compIso n hn
  ```
  see L920–L929.
- **Result**: kernel-only axioms verified.
- **Insight**: Mirrors the iter-039 / iter-042 / iter-043 `_curve` pattern: a thin dot-notation wrapper that saves call sites in the curve setting from re-typing `Scheme.toModuleKSheaf C`. Will be used by the iter-051 `IsAffineHModuleVanishing k C (toModuleKSheaf C)` producer instance.

## Key findings / proof patterns

- **Carrier-predicate + abstract-consumer + `_curve` triple-declaration package** *(iter-048, generalises iter-040 / iter-041 / iter-043)*: when Čech-side combinatorial vanishing must be packaged as a typeclass-flavoured carrier and the substantive comparison work is queued for a later iteration, the cleanest decomposition is: `(1)` `class IsX … : Prop` carrier with a single `Subsingleton` field, `(2)` abstract consumer transporting via an *explicit* `compIso` data argument (the comparison is data, not a `Prop` field), `(3)` `_curve` specialisation as a thin dot-notation wrapper. The explicit `compIso` argument is the key design choice — it lets iter-048 land cleanly without waiting on iter-049's substantive comparison theorem.
- **Explicit argument over class field for data** *(iter-048, new this iteration)*: when a downstream chain needs both a `Prop`-flavoured carrier (combinatorial vanishing) and a data-flavoured comparison map (`LinearEquiv`), they cannot share a `Prop`-valued class. The clean solution is to keep the carrier as a class and pass the data as an explicit argument. Decouples each piece into its own iteration.
- **Verbatim probe-confirmed body, single combined Edit pattern continues** *(iter-035 → iter-048)*: 11 of 14 iterations zero-corrective-Edit, 1 with cosmetic corrective (iter-044, `op` → `Opposite.op`), 1 with cosmetic corrective (iter-046, `include adj in` → `include adj`). **Iter-048 = second zero-corrective Edit in a row** (iter-047 → iter-048). Pattern firmly established and now scaling cleanly across class+theorem+theorem cohorts.
- **`haveI` + named-argument syntax `(F := F) (𝒰 := 𝒰)` for class-field extraction** *(iter-048, mirrors iter-043)*: extracting a class field with explicit-named arguments works directly inside a tactic block.
- **`.symm.toEquiv.subsingleton` as `Subsingleton` transport along a `LinearEquiv`** *(iter-048, new this iteration as a transport vehicle)*: `LinearEquiv` does not carry a direct `Subsingleton` transport, but `.toEquiv.subsingleton` recovers it via the underlying `Equiv`.

## Blueprint markers updated

The iter-048 plan-agent already pre-marked all three new declarations' statement and proof blocks with `\leanok` in `blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex` § *Čech-side acyclicity carrier (iter-048)* (L962–L1019). This pass — review-side re-verification of compilation (clean diagnostics) and axioms (kernel-only on all three) — confirms the pre-marks are valid:

- `Cohomology_StructureSheafModuleK.tex`, `def:Scheme_IsCechAcyclicCover`: pre-marked `\leanok` on statement (L969) — **verified valid this pass** (declaration exists, file compiles).
- `Cohomology_StructureSheafModuleK.tex`, `thm:Scheme_subsingleton_HModule'_supr_of_isCechAcyclicCover`: pre-marked `\leanok` on statement (L984) — **verified valid this pass**.
- `Cohomology_StructureSheafModuleK.tex`, `thm:Scheme_subsingleton_HModule'_supr_of_isCechAcyclicCover`: pre-marked `\leanok` on proof (L996) — **verified valid this pass** (kernel-only axioms, no sorry).
- `Cohomology_StructureSheafModuleK.tex`, `thm:Scheme_subsingleton_HModule'_supr_of_isCechAcyclicCover_curve`: pre-marked `\leanok` on statement (L1001) — **verified valid this pass**.
- `Cohomology_StructureSheafModuleK.tex`, `thm:Scheme_subsingleton_HModule'_supr_of_isCechAcyclicCover_curve`: pre-marked `\leanok` on proof (L1013) — **verified valid this pass** (kernel-only axioms).

`blueprint/lean_decls` already contains all three new entries (L49–L51: `IsCechAcyclicCover`, `subsingleton_HModule'_supr_of_isCechAcyclicCover`, `subsingleton_HModule'_supr_of_isCechAcyclicCover_curve`). **No additional marker edits required from the review agent this iteration** — pre-marks are accurate. **Fourth iteration in a row of plan-agent pre-marking with review-side validation** (iter-045 → iter-046 → iter-047 → iter-048).

No `\notready` markers remain in any chapter (verified).

## Recommendations for next session (iter-049)

See `recommendations.md`. The Čech-side acyclicity carrier predicate and its consumer are now in place. Highest-priority track for iter-049: **Čech-vs-derived comparison theorem** — the substantive next piece that supplies the `compIso` argument iter-048's consumer accepts. Once iter-049 lands, the iter-051 `IsAffineHModuleVanishing` producer is (along with iter-050+ Čech-side producers) one substantive step away.
