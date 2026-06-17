# Recommendations for the next plan iteration (post iter-044)

## HIGH — blueprint coverage debt must be cleared before/at the next QcohTildeSections lane
The 5 new axiom-clean decls have NO blueprint blocks (all `lean_aux` / unmatched). The planner should
dispatch a **blueprint-writer** on `Cohomology_CechHigherDirectImage.tex` to author blocks for them.
Per lean-vs-blueprint-checker `qts` (`.archon/task_results/lean-vs-blueprint-checker-qts.md`):

1. **Do NOT pin `\lean{tile_scalar_compat}` onto `lem:tile_section_comparison`.** Statement mismatch:
   the Lean lemma is the scalar equality at `V=⊤` (`r • x = (algebraMap r) • x`), the block asserts a
   full natural `R_g`-linear iso over all `V`. Author a **dedicated block** for `tile_scalar_compat`
   instead (the scalar-compatibility core), and either restate `lem:tile_section_comparison` to match
   what the Lean route actually delivers, or keep it as the (still-unformalized) target the localization
   proof consumes — but its sketch must stop calling the residual "a single focused sub-proof" (it took
   4 helper lemmas + 1M heartbeats) and must not conflate underlying-type carrier equality (holds) with
   bundled-module defeq (does NOT hold for `modulesSpecToSheaf`).
2. **Substantive helpers needing their own blocks:** `key_morph` (Γ-Spec naturality of `specAwayToSpec`)
   and `tile_section_ring_identity` (the assembled route-(A) morphism identity) — both are explicit
   route-(A) steps in the existing sketch.
3. **Minor helpers needing small blocks:** `appTop_appIso_inv_eq_res` (general open-immersion
   section-restriction lemma) and `tile_appIso_comp` (`comp_appIso` fold).

After the writer round + green build, take the **same-iter fast path** (re-dispatch blueprint-reviewer
scoped to this chapter) so the next `tile_section_localization` lane is not blocked an extra iter.

## HIGH — next prover target: `tile_section_localization` (the keystone leaf), now fully unblocked
All ingredients are axiom-clean and present (Sub-lemma A, base-ring descent, the two rfl bridges,
`tile_scalar_compat`). The remaining work is engineering (~100–150 LOC), NOT a math wall. **Critical
guidance the planner must put in the objective** (from the prover's task result + checker `qts`):
- **Work at the UNDERLYING-type / `F.val` level, NOT the bundled level.** Kernel-confirmed: the bundled
  carriers `Γ_{R_g}(⊤, tile) : ModuleCat R_g` and `Γ_R(D(g), F) : ModuleCat R` are NOT the same type, so
  `m_tile.restrictScalars R = ρ` FAILS at the bundled `modulesSpecToSheaf.obj` level. The recipe:
  `letI` the `Module R` + `IsScalarTower R R_g` instances on the tile's underlying section type
  (`IsScalarTower` supplied by `tile_scalar_compat` via `IsScalarTower.of_algebraMap_smul`), feed
  `m_tile` (R_g-linear) to `isLocalizedModule_powers_restrictScalars_of_algebraMap`, transport the opens
  by `eqToHom` (`tile_image_opens_identities`).
- **`tile_scalar_compat` covers `V=⊤` ONLY.** The localization also needs scalar compatibility at
  `V=D(f̄)` (the `D(gf)` overlap). Either generalize `tile_scalar_compat` to arbitrary `V`, or establish
  the `V=D(f̄)` instance separately. Surface this in the objective so the prover doesn't assume the ⊤
  case suffices.

## MEDIUM — deprecated `Sheaf.val` in load-bearing type signatures (lean-auditor `iter044`)
`Sheaf.val` (deprecated → `ObjectProperty.obj`) appears in the **type signatures** of
`modulesSpecToSheaf_smul_eq` (L732) and `modulesRestrictBasicOpen_smul_eq` (L741) in
`QcohTildeSections.lean`. These power `tile_scalar_compat`; a Mathlib API migration will break their
statements (not just proofs). Not urgent (build green now), but schedule a refactor pass before the
alias is removed upstream. Report: `.archon/task_results/lean-auditor-iter044.md`.

## LOW — stale in-file block comment (cosmetic, prover-owned)
`QcohTildeSections.lean` ~L894–934: the "PARTIAL this iter" heading is stale (`tile_scalar_compat`
closed); the tactic-prefix description omits the terminal `convert … using 2`. Have the next prover
touching this file tidy it.

## Coverage debt (for the planner — `archon dag-query unmatched`)
6 unmatched `lean_aux` nodes: 1 pre-existing dead (`CechAcyclic.affine`) + the 5 new this iter
(`appTop_appIso_inv_eq_res`, `key_morph`, `tile_appIso_comp`, `tile_section_ring_identity`,
`tile_scalar_compat`). The 5 new ones are cleared by the HIGH blueprint-writer item above.

## Do NOT
- Do NOT re-dispatch `tile_scalar_compat` or its helpers — all SOLVED, axiom-clean, kernel-verified.
- Do NOT attempt `tile_section_localization` at the bundled `modulesSpecToSheaf.obj` level — kernel-
  confirmed dead end (carrier type mismatch). Underlying-type level only.
- Do NOT resurrect the dormant Route-P assets or `lem:tilde_restrict_basicOpen`.

## Process note (progress-critic at iter-043 flagged CHURNING — now resolved)
The CHURNING verdict fired on "PARTIAL × 3"; the planner's corrective (blueprint expansion before
re-dispatch, dispatch=OK) was vindicated — the route converged this iter with the named target CLOSED.
The next lane targets genuinely new work (`tile_section_localization` assembly), so the CHURNING
condition no longer applies. If that assembly stalls on a concrete term-mode wall, escalate to a
mathlib-analogist (api-alignment) with the actual error state (the iter-043/044 reversal signal).
