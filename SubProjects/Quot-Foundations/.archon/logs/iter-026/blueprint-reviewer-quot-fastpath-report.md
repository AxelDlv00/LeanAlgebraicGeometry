# Blueprint Review Report

## Slug
quot-fastpath

## Iteration
026

## Scope
Scoped re-review of `blueprint/src/chapters/Picard_QuotScheme.tex` only — specifically the gap1 / G1-core / keystone triad to verify the hard gate clears for dispatching a mathlib-build prover on `lem:qcoh_affine_section_localization`.

---

## \uses{} edge audit (directive check 1)

### Verified dependency chain: G1-core → gap1 → keystone

**G1-core** `lem:qcoh_affine_section_localization` (line 2593):
- Statement `\uses{}`: `{lem:isLocalization_basicOpen_mathlib}` — uses ONLY the Mathlib localization-on-affine anchor. ✅
- Proof `\uses{}`: `{lem:isLocalization_basicOpen_mathlib}` — same. ✅
- No backward reference to gap1 or the keystone. ✅

**gap1** `lem:qcoh_affine_isIso_fromTildeΓ` (line 2641):
- Statement `\uses{}`: `{lem:qcoh_affine_section_localization, lem:isLocalizedModule_tilde_restrict}` — uses G1-core + the Spec-local tilde restriction Mathlib lemma. ✅
- Proof `\uses{}`: `{lem:qcoh_affine_section_localization, lem:isLocalizedModule_tilde_restrict}` — same. ✅
- No reference to the keystone. ✅

**Keystone** `lem:qcoh_section_localization_basicOpen` (line 2471):
- Statement `\uses{}`: `{lem:isLocalization_basicOpen_mathlib, lem:qcoh_affine_isIso_fromTildeΓ, lem:isLocalizedModule_restrict_of_isIso_fromTildeΓ}` — uses gap1 + the affine engine (`isLocalizedModule_restrict_of_isIso_fromTildeΓ`). ✅
- Proof `\uses{}`: `{lem:isLocalization_basicOpen_mathlib}` — proof body restates the argument through the affine identification; gap1 and the affine engine are captured at statement level, which is sufficient for leanblueprint dependency tracking. ✅

**No block uses a descendant.** Confirmed by traversal: G1-core ← nothing in the gap1/keystone direction before it; gap1 ← nothing from the keystone; keystone ← nothing from `def:modules_annihilator` (which uses it) or anything downstream. ✅

---

## Proof-skeleton quality audit (directive check 2)

### G1-core proof skeleton (lines 2612–2638)

The 4-step skeleton is:

1. **Cover-refine to basic opens** — "The quasi-coherence datum gives an open cover of Spec R on each member of which M is a cokernel of free module sheaves. Basic opens D(g) form a basis of Spec R, so refine to a cover by basic opens; since Spec R is quasi-compact, finitely many D(g_1), ..., D(g_n) suffice."

   **Judgment**: Clear and startable. The prover knows to use `PrimeSpectrum.isBasis_basic_opens` for the basis, `CompactSpace (PrimeSpectrum R)` for finiteness, and `Presentation.map` (or the `over`-restriction functor) to carry the QC presentation to each basic open. The step does NOT name these Mathlib anchors explicitly in prose or `\uses{}` (see must-add finding below), but the argument is correct and not hand-wavy.

2. **Locally M is a tilde sheaf** — "On each D(g_a) ≅ Spec R_{g_a} the local cokernel-of-frees presentation makes M|_{D(g_a)} ≅ tilde(N_a) for the R_{g_a}-module N_a = Γ(M, D(g_a)), using that Γ(Spec R, D(g_a)) = R_{g_a} (lem:isLocalization_basicOpen_mathlib)."

   **Judgment**: The step is correct. The Mathlib lemma `isIso_fromTildeΓ_of_presentation` (Tilde.lean:398) converts a local `Presentation` into the tilde isomorphism. The blueprint does not name this explicitly, but a prover will find it immediately via `lean_leansearch`. The step names `lem:isLocalization_basicOpen_mathlib` for the ring identification, which is the correct Mathlib anchor. **Not hand-wavy.**

3. **Sheaf equalizer + flat descent** — "The sheaf condition over the finite cover {D(g_a)} presents N = Γ(M, ⊤) as the equalizer N → ∏_a N_a ⇉ ∏_{a,b} Γ(M, D(g_a g_b)). Localizing this finite equalizer at powers f is exact (localization is flat, hence preserves finite limits), and the localized diagram is the same equalizer computing Γ(M, D(f)) over the cover {D(g_a) ∩ D(f)}. Hence N_f ≅ Γ(M, D(f)), compatibly with the restriction map."

   **Judgment**: The argument is mathematically correct. The key identifications are:
   - Sheaf condition over {D(g_a)} → equalizer (standard sheaf API)
   - Localization is flat → `IsLocalization.flat` (Flat/Localization.lean:36, named in the analogies file)
   - Localized equalizer = equalizer for D(f): uses D(g_a) ∩ D(f) = D(g_a f), applies the tilde-restriction result on each D(g_a f) ⊂ D(g_a) (step 2 output), and applies the sheaf condition over {D(g_a f)} for the cover of D(f)
   - The "localized diagram is the same equalizer" is the one step that could be made more explicit (name the sheaf API that gives Γ(M, D(f)) as the equalizer over {D(g_a f)}), but the argument is traceable and not a genuine hand-wave. A mathlib-build prover can complete it.

4. **Conclusion**: "Therefore Γ(M,⊤) → Γ(M, D(f)) is the localization N → N_f, i.e. IsLocalizedModule(powers f)." **Clear.** ✅

**Overall judgment on G1-core skeleton:** Detailed enough for a mathlib-build prover to start. No step contains a logical gap; the two slightly sparse steps (how the Presentation carries to refined cover elements; the localized-equalizer identification) are resolvable by API search without guessing the mathematical content.

### Gap1 proof (lines 2663–2678)

The proof is:
1. Check iso on each basic open D(f) via fully-faithful reflection (basis + `FullyFaithful.reflectsIsomorphisms` via `SpecModulesToSheafFullyFaithful`)
2. On D(f): source N_f from `lem:isLocalizedModule_tilde_restrict`; target Γ(M, D(f)) from G1-core (`lem:qcoh_affine_section_localization`)
3. Canonical map intertwines them via `toOpen_fromTildeΓ_app` (named explicitly in proof text)
4. `IsLocalizedModule.linearEquiv` → component is iso → done

**Judgment**: This is the G1-assemble route from the analogies file. All Mathlib ingredients are named or implied. **This is no longer hand-waving the global step.** The prior conditional verdict's specific concern (gap1 hand-waving the globalization) is resolved: the proof reduces the global iso to component isos on each basic open, each of which follows from two named localization witnesses (source via `isLocalizedModule_tilde_restrict`, target via G1-core) plus `IsLocalizedModule.linearEquiv`. ✅

---

## Must-add findings (soon severity — do not block prover dispatch)

### G1-core proof block missing `\mathlibok` anchors

G1-core's proof references three Mathlib facts that have no `\mathlibok` blocks in the chapter and are therefore absent from G1-core's proof `\uses{}`:

1. **`CompactSpace (PrimeSpectrum R)`** — needed in step 1 ("Spec R is quasi-compact, finitely many D(g_a) suffice"). Mathlib: `PrimeSpectrum.compactSpace` (Spectrum/Prime/Topology.lean:291, per the analogies file). Should become `\mathlibok`/`\lean{PrimeSpectrum.compactSpace}` and be wired into G1-core's proof `\uses{}`.

2. **`isIso_fromTildeΓ_of_presentation`** — needed in step 2 ("local cokernel-of-frees presentation makes M|_{D(g_a)} ≅ tilde(N_a)"). Mathlib: Tilde.lean:398. Should become a `\mathlibok` anchor and be wired into G1-core's proof `\uses{}`.

3. **`IsLocalization.flat`** — needed in step 3 ("localization is flat, hence preserves finite limits"). Mathlib: Flat/Localization.lean:36. Should become a `\mathlibok` anchor and be wired into G1-core's proof `\uses{}`.

**Severity rationale**: The out-of-order dispatch risk is minimal because (a) the analogies file already names all three Mathlib lemmas by file and line, (b) a mathlib-build prover will find them via `lean_leansearch`, and (c) these are pure Mathlib dependencies with no project-proof obligation. The missing `\mathlibok` blocks are a blueprint-graph completeness issue but do not create a mathematical gap or misdirect the prover. **Classified soon, not must-fix-this-iter.** A blueprint-writer pass should add these before the next mandatory blueprint-reviewer dispatch.

---

## Confirmation: rewrite did not break other wiring

- `def:modules_annihilator` (line 2323) uses `{lem:annihilator_localization_eq_map, lem:qcoh_section_localization_basicOpen}` — wiring intact, keystone correctly gates the annihilator definition. ✅
- `def:schematic_support`, `def:has_proper_support`, `def:quot_functor`, `def:grassmannian_scheme`, `thm:grassmannian_representable` — `\uses{}` edges examined; the Grassmannian stubs reference labels (`thm:relative_spec_exists`, `thm:relative_spec_univ`, `def:gr_glued_scheme`, `lem:gr_separated`, `lem:gr_proper`) that are out-of-scope for this review per the directive. The NOTE on `thm:grassmannian_representable` (line 2958–2969) pre-flags the skeleton weakness; this is pre-existing and not introduced by the rewrite. ✅
- The SNAP / annihilator / locally-free sections reference only their declared dependencies; none uses a descendant of the keystone. ✅

---

## Per-chapter

### blueprint/src/chapters/Picard_QuotScheme.tex
- **complete**: true (for the gap1/G1-core/keystone triad; the Grassmannian skeleton incompleteness is pre-existing and explicitly flagged by NOTEs)
- **correct**: true (all \uses{} edges verified; math is sound; dependency order fixed per analogies file recommendation)
- **notes**:
  - **soon** — G1-core proof `\uses{}` is missing `\mathlibok` anchors for `CompactSpace (PrimeSpectrum R)`, `isIso_fromTildeΓ_of_presentation`, `IsLocalization.flat`; add all three as `\mathlibok` blocks and wire into `lem:qcoh_affine_section_localization` proof `\uses{}`. Blueprint-writer directive; does not block prover dispatch given analogies file names all three.
  - **informational** — G1-core step 3 "localized diagram is the same equalizer computing Γ(M, D(f)) over the cover {D(g_a) ∩ D(f)}" could explicitly state: apply the sheaf condition for the cover {D(g_a f)} of D(f) using Γ(M, D(g_a f)) = (N_a)_f from the local tilde result, to identify the localized equalizer with the D(f)-sections equalizer. Informational refinement only; the argument is traceable as written.

---

## Severity summary

**For the specific hard-gate question (prover dispatch on G1-core):**

The prior conditional verdict's must-fix (gap1 hand-waving the global step) is resolved. No new must-fix-this-iter items touch the gap1/G1-core/keystone triad. The soon finding (missing `\mathlibok` anchors) does not block the prover and should be addressed by a writer pass in the same iter.

**Severity summary: HARD GATE CLEARS for dispatching a mathlib-build prover on `lem:qcoh_affine_section_localization`.**

---

## Overall verdict

The rewrite fixes the prior conditional verdict: the dependency circularity is eliminated, G1-core is now the foundational gap with a concrete 4-step proof skeleton, and gap1 follows non-circularly by cheap Mathlib glue. The chapter is complete and correct for the specific purpose of dispatching a mathlib-build prover on `AlgebraicGeometry.Scheme.Modules.isLocalizedModule_basicOpen_of_isQuasicoherent`. One soon-severity writer directive is open (add 3 `\mathlibok` anchors to G1-core's proof block) but does not gate prover dispatch.
