# Strategy Critic Report

## Slug
capstone-iter078

## Iteration
078

## Routes audited

### Route: A — acyclic-resolution comparison (CHOSEN) + §P5b capstone

- **Goal-alignment**: PARTIAL — the route reaches a *correct instance* of Tag 02KE, but the deliverable's separatedness packaging is over-specified and its scope is the `X`-separated case (see soundness + the redundancy finding below). The directive's one-paragraph goal ("f qc separated, finite affine cover, all intersections affine") is itself an *incomplete* statement of 02KE — that hypothesis set is FALSE for general `S` (an affine source `Uσ → S` need not be affine when `S` is non-separated, so `Rᵏfₓ Cⁿ` need not vanish). The project correctly discovered this and added `[S.IsSeparated]`; that is a point in its favor, not against it. Net: the *math content* of the deliverable is faithful to what 02KE genuinely requires; the *hypothesis list* is not minimal.
- **Mathematical soundness**: PASS — the chain is the textbook proof and I found no structural error. Augmented Čech `0→F→C⁰→C¹→⋯` is a resolution (`cechAugmented_exact`, cover/module-agnostic ✓); each `Cⁿ = ∏_{|σ|=n+1} (jσ)_*(F|_{Uσ})` is termwise right-`f_*`-acyclic via `Rᵏf_*((jσ)_*H) ≅ Rᵏ(f∘jσ)_*H` (needs `jσ` affine ⟸ `[X.IsSeparated]` + `IsAffine Uσ`) composed with `Rᵠ(f∘jσ)_* = 0` (needs `f∘jσ` affine ⟸ `[S.IsSeparated]` + `IsAffine Uσ`, Stacks 01SG / `isAffineHom_of_isAffine_of_isSeparated`); finite-product acyclicity (`rightAcyclic_finite_prod`, finite cover); then Leray (`rightDerivedIsoOfAcyclicResolution`, P4) gives `Hⁱ(f_* C•) ≅ Rⁱf_*F`; `f_* C•` is the relative Čech complex. This is Leray's acyclicity lemma on the augmented Čech resolution — the right tool, no spectral sequence. I verified the load-bearing helpers exist in-tree (`CechTermAcyclic.lean`: `isAffineHom_of_isAffine_of_isSeparated:153`, `isAffineOpen_coverInterOpen [X.IsSeparated]:296`, `pushPullObj_opens_pushforward_acyclic [X.IsSeparated][S.IsSeparated]:655`).
- **Sunk-cost reasoning detected**: no.
- **Infrastructure-deferral detected**: no (accepted dependency). The `hres` family (`∀ n σ, HasInjectiveResolutions (coverInterOpen 𝒰 σ).Modules`) and the global `[HasInjectiveResolutions X.Modules]` are real theorems (Grothendieck: `O_X`-mod categories have enough injectives) carried as explicit hypotheses because Mathlib cannot synthesize them. This is *consistent with the protected target's own convention* — the frozen `cech_computes_higherDirectImage` itself carries `[HasInjectiveResolutions X.Modules]` — so it is not a goal weakening relative to the mathematician-frozen signature. Worth recording that the deliverable is therefore *conditional* on a Mathlib gap, but the choice matches the protected sig and the producer documents it (`CechTermAcyclic.lean:34–37`).
- **Phantom prerequisites**: none. Spot-checked `AlgebraicGeometry.IsSeparated.of_comp` (VERIFIED), `IsSeparated.instCompScheme` (VERIFIED), `IsSeparated.comp_iff` (VERIFIED); P4 `rightDerivedIsoOfAcyclicResolution` and producer lemmas present in-tree.
- **Effort honesty**: reasonable — `~1` iter / `~20` LOC for "thread `[S.IsSeparated]`+`hres` into the sig and pass `hres n` at the line-207 call" matches the actual residual I read in `CechToHigherDirectImage.lean:197–217` (the assembly body is already written; producer is green-verified).
- **Parallelism under-exploited**: no — single focused consumer lane is correct here; producer is frozen-done and the obligation is one signature edit.
- **Verdict**: CHALLENGE — route is mathematically SOUND; the must-fix is the false minimality claim / redundant hypothesis below, plus a one-line scope acknowledgement.

**The redundant-hypothesis finding (must-fix).** STRATEGY.md (§P5b) and `CechTermAcyclic.lean` assert the four added hypotheses are "each mathematically forced." This is **false for `[X.IsSeparated]`**. The deliverable inherits `[IsSeparated f]` from the frozen sibling and adds `[S.IsSeparated]`; given both, `[X.IsSeparated]` is *derivable* — `X ⟶ ⊤` factors as `f ≫ (S ⟶ ⊤)` and `IsSeparated.instCompScheme` makes the composite separated. (Conversely `[X.IsSeparated]` alone implies `[IsSeparated f]` by `IsSeparated.of_comp`, with no hypothesis on `S`.) So among `{[IsSeparated f], [X.IsSeparated], [S.IsSeparated]}` exactly **one of the first two is redundant**: the minimal set is `[S.IsSeparated]` + *one* of `{f-sep, X-sep}`. The current/planned signature (`CechToHigherDirectImage.lean:198`) carries all three. Recommended: drop `[X.IsSeparated]` from the consumer signature and synthesize it internally (`haveI : X.IsSeparated := ⟨…⟩` from `[IsSeparated f]` + `[S.IsSeparated]`) before calling the producer — the producer may keep using `[X.IsSeparated]` as an instance argument. This is low-effort, makes the theorem strictly cleaner/stronger, and removes the false "each forced" claim. Acceptable alternative: keep `[X.IsSeparated]` for readability but **correct STRATEGY.md** to say "forced up to the separated-cancellation redundancy; carried explicitly for the producer."

**Scope note (must-acknowledge, not block).** Even minimized, the deliverable requires `S` separated *and* `X` separated (one of the two free). Canonical 02KE's literal hypothesis is "all finite intersections affine," which the doubled-line shows is strictly weaker than `X` separated (a non-separated scheme can still have all finite cover-intersections affine and all `jσ` affine). The chosen route — routing termwise acyclicity through `Rᵠ(jσ)_* = 0` for `jσ` an *affine* morphism — genuinely needs `jσ` affine for **all** affine opens, i.e. `[X.IsSeparated]`, not merely the finitely many cover-intersections affine. So the deliverable is the `X`-separated specialization of 02KE. That is the overwhelmingly common case and a legitimate scope; it should simply be *stated* as such rather than presented as the unconditional Tag 02KE.

### Route: SS — two spectral sequences (REJECTED)

- **Verdict**: SOUND — correctly rejected; both sequences absent from Mathlib (multi-kLOC) and it rests on the same `injective_cech_acyclic` brick as A, so no advantage. Accurate.

### Route: the acyclicity bridge (torsor-free)

- **Verdict**: SOUND — the P3 standard-cover-vanishing → (1)`injective_cech_acyclic` + (2)`ses_cech_h1` + (3)01EO dimension-shift chain breaks the affine-vanishing circular regress without ever invoking affine vanishing. Logic is non-circular and the bricks are reported done.

### Route: `cechAugmented_exact` — sections/sheafification

- **Verdict**: SOUND — reflect `IsZero(Hᵖ)` through faithful additive `toSheaf`; homology sheaf = sheafification of presheaf homology; presheaf homology locally zero on `{V ⊆ some Uᵢ}` via the prepend-`i_fix` contracting homotopy; vanishes under sheafification. The cited dead-ends (stalk functor, tilde/standard-cover discharger, naive "section complex exact over each affine V" = circular) are correctly identified. Done in-tree.

### Route: absolute cohomology — Ext of corepresenting object (Form B)

- **Verdict**: SOUND — `Hᵖ(U,F) := Extᵖ(jShriekOU U, F)` with `jShriekOU = sheafify(free(yoneda U))` keeps the SES in `X.Modules`, sidestepping the restriction-preserves-injectives wall (≈200–500 LOC `j_!`). Off-the-shelf injective vanishing + covariant LES + `H⁰≅Γ`. The Form A / `rightDerived` / `Sheaf.H` discards are well-reasoned; reversal signal (Ext universe pain → Route γ Čech colimit) is recorded.

## Format compliance

- **Size**: 172 lines / 20419 bytes — **over budget** (~12 KB ceiling exceeded by ~70%; line count is within the 250 limit, but the byte budget is the binding one).
- **Headings**: PASS — exactly `## Goal`, `## Phases & estimations`, `## Completed`, `## Routes`, `## Open strategic questions`, `## Mathlib gaps & new material`, in canonical order.
- **Per-iter narrative detected**: yes — pervasive in prose, e.g. `"general statement false — iter-077 single-element ℙ¹/O(-2) counterexample"`, `"the iter-077 mis-convergence lesson"`, `"P5b relocation (iter-077 decision)"`, `"RESOLVED (iter-059, strategy-critic)"`, `"GREEN-VERIFIED iter-078"`. These are narrative iter references in `## Routes` and `## Open strategic questions` prose, not the permitted bare-iter cells of the `## Completed` ledger.
- **Accumulation detected**: borderline — `## Completed` is at 12 rows (right at the ~12 soft bound) and several cells (01I8, Sub-brick A, 02KG) are very long multi-clause paragraphs. `## Routes` carries a one-line `Route SS — REJECTED` tombstone (acceptable) but the §P5b subsection has grown into a multi-paragraph narrative.
- **Table discipline**: FAIL — the single active `## Phases & estimations` row puts multi-sentence prose in cells (`Key Mathlib needs` = "Producer … GREEN-VERIFIED done (iter-078, `lake env lean` exit-0). Residual = consumer signature threading only. See Routes §P5b."; `Risks` likewise). Cells must be one short line.
- **Format verdict**: NON-COMPLIANT — driven by the 70%-over byte budget + pervasive per-iter narrative + multi-sentence table cells. Structure (headings/order) is correct, so this is a trim-in-place, not a re-skeleton: move iter-specific narrative to `iter/iter-078/plan.md`, compress §P5b to a few lines, shorten Completed/Phases cells.

## Must-fix-this-iter

- Route A §P5b: CHALLENGE — `[X.IsSeparated]` is **redundant** given the inherited `[IsSeparated f]` + the planned `[S.IsSeparated]` (`IsSeparated.instCompScheme`/`of_comp`, both VERIFIED). The claim that the four added hypotheses are "each mathematically forced" is false. Planner must either (a) drop `[X.IsSeparated]` from `cech_computes_higherDirectImage_of_affineCover` and synthesize it internally, or (b) keep it but correct STRATEGY.md's "each forced" wording to note the separated-cancellation redundancy.
- Route A §P5b: CHALLENGE — acknowledge in STRATEGY.md that the deliverable is the `X`/`S`-separated specialization of Tag 02KE (canonical hypothesis "intersections affine" is strictly weaker than `[X.IsSeparated]`, which the chosen `jσ`-affine route genuinely needs). State the scope rather than presenting `_of_affineCover` as unconditional 02KE.
- Format: NON-COMPLIANT — STRATEGY.md is ~20 KB (>12 KB) with pervasive per-iter narrative in prose and multi-sentence table cells. Trim in-place this iter: relocate iter-NNN narrative to the iter sidecar, compress §P5b and the Completed/Phases cells.

## Overall verdict

The acyclic-resolution route (Route A) is mathematically SOUND — it is the canonical Leray-acyclic-resolution proof of Stacks 02KE applied to the augmented Čech complex, with no structural error, and the residual is a mechanical signature edit on an already-written assembly. The project's discovery that `[S.IsSeparated]` is genuinely required (the directive's own goal paragraph understates 02KE for general `S`) is correct and to its credit. The one substantive challenge is hypothesis minimality: contrary to the strategy's "each mathematically forced" claim, `[X.IsSeparated]` is redundant given the inherited `[IsSeparated f]` plus the added `[S.IsSeparated]` (verified against `IsSeparated.instCompScheme`/`IsSeparated.of_comp`), so the deliverable should either drop it or correct the claim — and should state that it proves the `X`-separated specialization of 02KE, not the literal "intersections-affine" statement. The `hres`/enough-injectives dependency is an accepted Mathlib gap consistent with the protected signature, not a goal-weakening deferral. Separately, STRATEGY.md is NON-COMPLIANT on format (20 KB vs the 12 KB ceiling, pervasive per-iter narrative, prose-heavy table cells) and must be trimmed in-place this iter.
