# Strategy Critic Report

## Slug
iter052

## Iteration
052

## Routes audited

### Route: A — acyclic-resolution comparison (CHOSEN)

- **Goal-alignment**: PASS — `rightDerivedIsoOfAcyclicResolution` (P4, built) delivers `Hⁱ(f_* C•) ≅ Rⁱf_* F`, and `Rⁱf_* F = ((pushforward f).rightDerived i).obj F` is exactly the frozen `higherDirectImage`. The remaining glue (`CechComplex.homology i ≅ Hⁱ(f_* C•)`) is the P5b line-679 assembly — acknowledged, not hidden.
- **Mathematical soundness**: PASS — the two inputs are correct: (i) augmented Čech complex is a resolution; (ii) each `Cᵖ = ∏(j_s)_*(F|_{U_s})` is `f_*`-acyclic. The acyclicity reduction is sound: `Rᵏf_*(Cᵖ)` is the sheafification of `V ↦ Hᵏ(f⁻¹V ∩ U_s, F)` (01XJ), and **separatedness** makes `f⁻¹V ∩ U_s` affine (`U_s` affine, `V ⊆ S` affine ⟹ `U_s ×_S V` affine), so it lands on affine Serre vanishing `affine_serre_vanishing` (02KG, CLOSING). This is the load-bearing use of the `separated` hypothesis and it checks out.
- **Sunk-cost reasoning detected**: no.
- **Infrastructure-deferral detected**: no — the resolution input `cechAugmented_exact` is being actively built, not deferred. But see the CHALLENGE on its chosen sub-route below.
- **Phantom prerequisites**: none. `rightDerivedIsoOfAcyclicResolution` is project-built (P4); `InjectiveResolution.extEquivCohomologyClass` VERIFIED present (the P5a last-mile Ext backing).
- **Effort honesty**: under-counted on the P5a row — the stalkwise reflection is framed as "thin assembly over existing pieces," but its step (1) likely pulls in the *separately-listed* `PreservesFiniteColimits (toSheaf)` gap (see Must-fix). Two gaps presented as independent are probably one coupled lane.
- **Verdict**: SOUND — keep Route A. The directive's first question ("does the gap size argue for an affine-basis route instead?") is answered NO: the affine-basis-sections alternative is **circular** (worked out under Alternative routes). Route A is the right top-level route; only the *sub-route for proving `cechAugmented_exact`* is contestable.

### Route: The acyclicity bridge (01EO/02KG, torsor-free)

- **Verdict**: SOUND — the non-circular chain `injective_cech_acyclic` + `ses_cech_h1` + dimension-shift `cech_eq_cohomology_of_basis` (01EO) consuming P3 standard-cover vanishing is correct and matches Stacks 02KE/01EO. It lifts standard-cover Čech vanishing to affine sheaf vanishing without ever assuming affine vanishing. First two bricks done; 01EO chain reported complete in `## Completed`.

### Route: 01I8 affine `F≅~(ΓF)` — section-localization (Route B)

- **Goal-alignment**: PASS — `qcoh_iso_tilde_sections` is unconditional (in `## Completed`, iter-048).
- **Verdict**: SOUND as mathematics, but this route is **DONE** and is double-booked: it sits in `## Completed` AND still occupies a full `### 01I8` subsection in `## Routes` carrying stale `[ACTIVE]` / "the live route" / "Keystone glue [ACTIVE]" labels. That is accumulation (a completed route squatting in the active `## Routes` section). See Format compliance.

### Route: Absolute cohomology realization — Ext of corepresenting object (Form B)

- **Mathematical soundness**: PASS — `H^p(U,F) := Ext^p(jShriekOU U, F)` with `jShriekOU = sheafify(free(yoneda U))` keeps the SES in `X.Modules` and sidesteps restriction-preserves-injectives. The three 01EO inputs (injective vanishing in the 2nd Ext arg, covariant LES, `H⁰≅Γ`) are off-the-shelf. Reversal signal (Ext universe pain → Route γ Čech colimit) is recorded.
- **Verdict**: SOUND.

### Route: SS — two spectral sequences (REJECTED)

- **Verdict**: SOUND rejection — both spectral sequences are absent from Mathlib (multi-kLOC) and rest on the same `injective_cech_acyclic` brick as A. Correctly excised to a one-liner.

## Format compliance

- **Size**: 147 lines / 15852 bytes — **over budget** (~12 KB ceiling; 15.8 KB is a hard Size violation, though line count is fine).
- **Headings**: PASS — exactly `## Goal`, `## Phases & estimations`, `## Completed`, `## Routes`, `## Open strategic questions`, `## Mathlib gaps & new material`, in canonical order; `## Completed` correctly placed between Phases and Routes.
- **Per-iter narrative detected**: yes — 7 prose/table iter references outside the legitimate `## Completed` `Iters` cell: lines 17–18 (Phases table cells: "Residual `htilde` LANDED iter-051", "object layer DONE iter-051", "route TBD by analogist iter-052"), line 70 ("DECIDED iter-041"), line 106 ("RESOLVED iter-041"), line 130 ("analogist iter-052"), line 135 ("DONE (iter-048, axiom-clean)"). These belong in iter sidecars.
- **Accumulation detected**: yes — the completed 01I8 route (already in `## Completed`) still occupies a full `### 01I8 affine F≅~(ΓF)` subsection in `## Routes` with stale `[ACTIVE]`/"live route" labels. Excise to a one-liner pointer like Route SS got.
- **Table discipline**: FAIL — `## Phases & estimations` "Key Mathlib needs" cells for the 02KG and P5a rows are multi-sentence paragraphs with bold/inline-code mini-essays, not the required "one short line per cell." This is the main driver of the byte overage.
- **Format verdict**: DRIFTED

## Alternative routes (suggested)

### Alternative: local contracting homotopy on the cover (for `cechAugmented_exact`)

- **What it looks like**: Prove the augmented complex is exact NOT via a generic "exact iff stalkwise exact" reflection, but via the classical extra-degeneracy homotopy applied **over each cover element `Uᵢ`**. Restricted to `Uᵢ`, the cover `{U_s ∩ Uᵢ}` contains `Uᵢ` itself, so the explicit "insert index `i`" operator `h : Cᵖ|_{Uᵢ} → C^{p-1}|_{Uᵢ}` is a genuine morphism of sheaves on `Uᵢ` (no stalks needed) and contracts the augmented complex `C•|_{Uᵢ}` onto `F|_{Uᵢ}`. Since `{Uᵢ}` covers `X`, exactness of `C•` follows from: restriction-to-an-open is exact (so `Hᵖ(C•)|_{Uᵢ} = Hᵖ(C•|_{Uᵢ}) = 0`) + a homology sheaf that is locally zero on a cover is zero.
- **Why it might be cheaper or sounder**: BOTH routes need the same combinatorial contracting-homotopy content (at a stalk you *still* construct the "insert index i" homotopy — the stalk route does not save that work). The stalk route then *adds*, on top of the homotopy: descend through `toSheaf` to `Sheaf AddCommGrp`, joint conservativity of the stalk family, and an exactness-reflection through `toSheaf` (which couples to the `PreservesFiniteColimits (toSheaf)` gap). The local-homotopy route replaces all of that with "restriction is exact" + "sheaf zero iff locally zero," which is strictly less infrastructure than the generic stalkwise-reflection criterion the strategy budgets at ~150–250 LOC. The homotopy machinery is partly reusable from P3's L3 combinatorial core and the already-built `cechAugmentedComplex` companions.
- **What the current strategy may have rejected**: unclear — the strategy jumps straight to the stalk criterion and does not mention the local-homotopy route. The one cost to confirm is that **restriction of `SheafOfModules` to an open is available and exact** in Mathlib; if that itself is heavy infra the advantage narrows, but the homotopy is needed either way.
- **Severity of the omission**: major — it is plausibly the cheaper path to the single largest remaining infra item, and the planner committed to the more expensive one without comparison.

## Must-fix-this-iter

- Route A / P5a: **CHALLENGE** — before sinking ~150–250 LOC into the generic stalkwise-exactness reflection for `cechAugmented_exact`, compare it against the local-contracting-homotopy-on-the-cover route (above). Both need the same homotopy; only the stalk route additionally needs the `toSheaf`→Ab descent + joint conservativity. Either adopt the cheaper route or record an explicit rebuttal naming why restriction-exactness for `SheafOfModules` makes it dearer than the stalk criterion.
- Route A / P5a: **CHALLENGE (hidden prereq + effort honesty)** — the stalkwise reflection's step (1) ("`X.Modules` complex exact ⟸ exact on Ab sheaves via `toSheaf` exact + faithful") needs `toSheaf` to *reflect* exactness, which requires its right-exact half = the separately-listed `PreservesFiniteColimits (SheafOfModules.toSheaf)` gap (~80–150 LOC). The P5a row is therefore under-counted, and the two "independent" gaps are one coupled lane. Additionally: that colimit gap's *only* stated motivation is `surj_of_vanishing` (02KG alt route), but 02KG now CLOSES via route B (change-of-ring) — so either `surj_of_vanishing`/the `toSheaf`-epi gap is now orphaned and should be dropped, or it is silently needed by P5a and must be re-attributed and re-estimated there. Resolve which.
- Format: **DRIFTED → restructure in place** — (a) trim to ≤12 KB by collapsing the multi-sentence Phases-table "Key Mathlib needs" cells to one short line each (push detail into the iter sidecar); (b) scrub the 7 in-prose `iter-NNN` references (lines 17–18, 70, 106, 130, 135); (c) excise the completed `### 01I8` Routes subsection (and its stale `[ACTIVE]` labels) to a one-liner, since it already lives in `## Completed`.

## Overall verdict

Route A is the soundest route to the protected goal and should stand: the abstract-Leray reduction is mathematically correct, separatedness is used exactly where it must be, and every named prerequisite (`SheafOfModules.toSheaf` + faithful/additive/`PreservesFiniteLimits`, `TopCat.Presheaf.stalkFunctor` + `app_isIso_of_stalkFunctor_map_iso`, `InjectiveResolution.extEquivCohomologyClass`) VERIFIED present. The directive's worry — that the new stalkwise gap argues for an affine-basis route — is answered NO in the *opposite* direction the directive feared: the affine-basis-sections route is **circular** (section-level exactness of `C•` over an affine `V` is the Čech cohomology `Ȟᵖ(V, {U_s∩V}, F)`, nonzero in degree ≥1 unless one already has the very affine vanishing under construction; only the *filtered colimit* / stalk is exact). So do not pursue the affine-basis route. The live challenge is narrower: the chosen *sub-route* for `cechAugmented_exact` (generic stalkwise reflection) is contestable — there is a concrete, likely-cheaper alternative (local contracting homotopy over each `Uᵢ` + restriction-exactness + sheaf-local-vanishing) that needs the same homotopy minus the descent-and-conservativity machinery, and the stalk route hides a coupling to the `PreservesFiniteColimits (toSheaf)` gap that makes its ~150–250 LOC estimate optimistic. No infrastructure-deferral finding (every gap carries a project-side plan and estimate). Format is DRIFTED — over the 12 KB budget with multi-sentence table cells, in-prose iter references, and a completed route still squatting in `## Routes`; restructure in place this iter.
