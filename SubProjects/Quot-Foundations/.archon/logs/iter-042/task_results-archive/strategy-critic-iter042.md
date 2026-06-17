# Strategy Critic Report

## Slug
iter042

## Iteration
042

## Routes audited

### Route: FBC (affine tilde-transport pivot)

- **Goal-alignment**: PASS — the route closes `lem:affine_base_change_pushforward` + `thm:flat_base_change_pushforward`, the named goal nodes; the parent-frozen map name is preserved, so merge-back is intact.
- **Mathematical soundness**: PASS — the pivot is structurally distinct from the exhausted conjugate route, not a relabeling (see below).
- **Sunk-cost reasoning detected**: no — the strategy *abandons* the 5-iter conjugate scaffold rather than justifying continuation by it; it explicitly demotes the conj scaffold to "a dictionary for whatever route consumes it." That is the correct anti-sunk-cost move.
- **Infrastructure-deferral detected**: no — the hardest prerequisite genuinely **changed** between routes. Old hardest: recognize the cross-layer composite as a single `conjugateEquiv` spanning five *abstract* scheme-level adjunction layers. New hardest: (i) basis-locality of `IsIso` for `SheafOfModules` (Mathlib-absent, well-posed, in FBC-A2) and (ii) affine restriction-compatibility of `.app U`, where the abstract adjunctions collapse to the *concrete* `Spec ⊣ Γ` / tilde adjunctions and the coherence becomes `pullback_spec_tilde_iso` + `regroupEquiv` (both DONE). Different construction, not the same gap moved one layer deeper.
- **Phantom prerequisites**: none asserted as existing — basis-locality of `IsIso` and `tensorEqLocusEquiv` are both flagged Mathlib-absent/to-build, not assumed.
- **Effort honesty**: reasonable for A1/A2 (3–6 each); the new route is unproven so the low end is optimistic, but the range is honest.
- **Parallelism under-exploited**: no — A1 and A2 are explicitly opened in parallel; A2 is independent of A1.
- **Verdict**: SOUND

**Load-bearing caveat the planner must keep in view (not a CHALLENGE — already covered by the documented reversal signal).** The entire pivot rests on one assumption: that obligation (1) — identifying `(pushforwardBaseChangeMap).app U` with the affine–affine model over the restricted square — is dischargeable from the *concrete* tilde/regroup data and ordinary naturality, **without** re-unfolding the abstract five-layer conjugate at each `U`. If unfolding the canonical map at `U` re-derives the same abstract mate value the conjugate route could not assemble, the bypass collapses into the exhausted route localized to affines. The bet that makes it tractable is precisely that affine-locally the adjunctions become `Spec ⊣ Γ` and the mate value is the already-proven `pullback_spec_tilde_iso`. The iter-042 blueprint section must make this collapse explicit — that is exactly what validates or kills the pivot. The strategy's stated reversal trigger ("if the tilde-transport blueprint surfaces a structural obstruction … escalate to the user") correctly fences this, so the route is sound to pursue. Note one wording hazard: STRATEGY.md says "Iso-ness … is already free (`conjugateIsoEquiv …`)" — that freeness is for the *conjugate* iso, NOT for the parent-frozen canonical map; bridging the two was the exhausted coherence. The sentence should not be read as implying IsIso of the canonical map is in hand.

### Route: GF (geometric `genericFlatness`)

- **Verdict**: SOUND — algebraic core done axiom-clean; the geometric wrapper (affine open `Spec A` with `A` a noetherian domain → finite affine cover of `p⁻¹(Spec A)` → per-patch algebraic form → `V = D(∏ fⱼ)`) is the standard Nitsure §4 globalization, and G1 is now unblocked by the closed gap1. `[IsIntegral S]`+`[QuasiCompact p]` hypotheses are named, not hidden.

### Route: QUOT

- **Goal-alignment**: PASS — covers `def:hilbert_polynomial`, `def:quot_functor`, `def:grassmannian_scheme`, `thm:grassmannian_representable`.
- **Mathematical soundness**: PASS — Hilbert-polynomial-as-graded-Hilbert-function via `existsUnique_hilbertPoly` + the (done) Hilbert–Serre rationality is sound; treating gap1 as closed is corroborated (no `sorry` in `isLocalizedModule_basicOpen_descent` / `isIso_fromTildeΓ_of_isQuasicoherent`; the 4 remaining `sorry`s are the protected iter-176 stubs). Pivoting to the consumer fan-out (G1-core 2-line corollary → gap2 affine-cover generalization → annihilator forward inclusion; P2 gap1-independent) is the right next QUOT focus and is well-decomposed.
- **Sunk-cost reasoning detected**: no.
- **Infrastructure-deferral detected**: yes (mild) — `SheafOfModules` tensor powers `L_s^{⊗m}` + lax-monoidal `Γ` ⟹ `def:sectionGradedRing`. See Infrastructure-deferral findings.
- **Phantom prerequisites**: none confirmed phantom; `Scheme.Modules.restrictFunctor`/`pullback` are corroborated by the completed gap1 build, and `existsUnique_hilbertPoly` is a real Mathlib decl (used in the done rationality engine).
- **Effort honesty**: SNAP-S1/S3 at 3–6 iters is under-counted (see Effort honesty below); the rest reasonable.
- **Parallelism under-exploited**: no — all four QUOT files import only Mathlib and are explicitly authorable in parallel.
- **Verdict**: SOUND (with the deferral note below)

## Format compliance

- **Size**: 161 lines / 17,359 bytes — **over budget** (~12 KB ceiling; line count is within the 250 limit, byte count is ~45% over).
- **Headings**: PASS — exactly `## Goal`, `## Phases & estimations`, `## Completed`, `## Routes`, `## Open strategic questions`, `## Mathlib gaps & new material`, in order. (`## What I need` is the directive wrapper, not part of STRATEGY.md.)
- **Per-iter narrative detected**: yes — pervasive in prose outside the Completed-ledger column. Representative verbatim: `"Conjugate route EXHAUSTED in-loop (5 iters 037–041 …)"`, `"iter-041 added a verified in-proof Γ-collapse stage"`, `"neither the one-shot reframing (iters 037–039) nor the layer-by-layer Fallback B (iters 040–041)"`, `"Q2 … RESOLVED (iter-042)"`, `"Element-ext (iter-035 dead end) stays DROPPED"`, `"P1 (per-affine local-tilde) DONE iter-034"`. These sit in `## Phases`, `## Routes`, and `## Open strategic questions` — exactly the per-iter history that belongs in iter sidecars, not STRATEGY.md.
- **Accumulation detected**: no — `## Completed` has 8 rows (within the ~12 bound); no completed phase lingers in the active table; no excised route still occupies a `## Routes` subsection.
- **Table discipline**: FAIL — the `Risks` column carries multi-sentence prose paragraphs (FBC-A1's Risks cell is ~5 sentences: "Conjugate route EXHAUSTED in-loop (5 iters 037–041: …). Per the armed protocol NO further … New route = affine tilde-transport: …"). The rule is one short line per cell.
- **Format verdict**: NON-COMPLIANT

## Infrastructure-deferral findings

### Deferred: `SheafOfModules` tensor powers (`L_s^{⊗m}`) + lax-monoidal `Γ` ⟹ `def:sectionGradedRing`

- **Required by goal**: yes — `def:hilbert_polynomial` (a named goal node) is defined via `m ↦ dim Γ(X_s, F_s ⊗ L_s^m)`; the section graded ring built from tensor powers is the input to the rationality engine. Without it, `def:hilbert_polynomial` cannot be stated as the strategy intends.
- **Current plan for building it**: STRATEGY.md names it under SNAP's "Key Mathlib needs" and calls it "a Mathlib-gradient sub-build owed regardless," but gives it no decomposition and no standalone estimate; it is folded inside the BLOCKED SNAP-S1/S3 row.
- **Timeline**: vague — inherits SNAP's `3–6` cell, which does not separately account for building monoidal tensor-power infrastructure + lax-monoidal `Γ` for `SheafOfModules` from scratch.
- **Verdict**: CHALLENGE — this is genuinely downstream and gating (Q1/Q3 still open), so it is not blocking *now*; but a goal-required Mathlib construction should not ride an unestimated wave inside a single BLOCKED row. The planner should give it its own sub-phase line with an honest estimate, or record an explicit rebuttal that it stays bundled until SNAP unblocks.

## Effort honesty

- **SNAP-S1/S3 (`3–6` iters)** — under-counted. The row bundles: the tensor-powers + lax-monoidal-`Γ` infrastructure above, the `def:sectionGradedRing` build, the S1 presentation input, and the `Φ_s` extraction — plus two unresolved route decisions (Q1, Q3). Building monoidal tensor-power infra for `SheafOfModules` alone is plausibly multi-iter; 3–6 for the whole bundle is optimistic. Recommend splitting the tensor-powers infra into its own row.
- **QUOT-repr (`6–12` iters, `~400–1000+` LOC)** — honest-but-deep. The wide range and `+` correctly signal depth; given the GR-cells/glue/sep/proper arc already consumed ~13 realized iters combined (per `## Completed`), the *high* end (12) is the realistic figure for Grassmannian-of-quotients + universal property + `RepresentableBy`, not the low end. Not a violation, but the planner should not bank on 6.
- All other active rows (FBC-A1/A2/B, GF-geo, QUOT-defs consumers) are reasonable given scope.

## Must-fix-this-iter

- **Format: NON-COMPLIANT** — three material deviations: (1) byte size 17.3 KB vs ~12 KB ceiling; (2) per-iter narrative pervasive in `## Phases`/`## Routes`/`## Open strategic questions` prose (move the 037–041 conjugate post-mortem and the "DONE iterNNN" tags into iter sidecars); (3) `Risks` table cells are multi-sentence prose. Restructure in-place this iter; relocate the historical conjugate-route detail to `iter/iter-042/plan.md`.
- **QUOT infrastructure-deferral: CHALLENGE** — `SheafOfModules` tensor powers / `def:sectionGradedRing` is required by `def:hilbert_polynomial` (a goal node) but has no standalone estimate. Give it its own sub-phase row with an iter estimate, or record an explicit rebuttal that it stays bundled under SNAP until unblocked.

## Overall verdict

The iter-042 strategy is **strategically sound on all three routes**; the only must-fix is document format. (1) The FBC pivot from the exhausted conjugate `gstar_transpose` route to affine tilde-transport is structurally well-founded, not illusory: the hardest prerequisite genuinely changes (abstract five-layer `conjugateEquiv` recognition → concrete affine-local tilde/regroup transport + basis-locality of `IsIso`), and the bypass of the *exact* section-level mate value is legitimate because `IsIso` only needs the map to factor through known isos, not its exact conjugate form. The single load-bearing risk — that obligation (1)'s affine restriction-compatibility secretly re-derives the abstract mate — is correctly fenced by the strategy's stated reversal-to-user trigger; the iter-042 blueprint must make the affine collapse explicit. (2) Treating gap1 as CLOSED and pivoting to consumers (G1-core/gap2/annihilator + P2) is the right next QUOT focus and is corroborated by the source (no `sorry` in the keystone decls). (3) The clearly-off estimate is SNAP-S1/S3's `3–6`, which under-counts the bundled `SheafOfModules` tensor-powers infrastructure — and the strategy defers that tensor-powers/`def:sectionGradedRing` construction, which is required for the stated goal node `def:hilbert_polynomial`, with no standalone timeline. Address the format restructure and give the deferred tensor-powers infra its own estimate; otherwise proceed on all three routes.
