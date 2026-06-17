# Session 5 (iter-005) — review summary

## Metadata
- **Iteration / session**: iter-005 / session_5.
- **Prover lane**: one (`AlgebraicJacobian/Cohomology/AcyclicResolution.lean`, `[prover-mode: mathlib-build]`, model sonnet).
- **Global sorry count**: 2 → 2 (unchanged). Both remaining are in `CechHigherDirectImage.lean`
  (`CechAcyclic.affine` L774, `cech_computes_higherDirectImage` L811 — P3/P5, out of scope).
- **`AcyclicResolution.lean`**: 0 → 0 sorries; **27 new declarations added**, all axiom-clean
  (`{propext, Classical.choice, Quot.sound}`); file compiles with 0 errors (style/long-line +
  unused-section-variable warnings only).
- **Targets attempted**: the 4 decomposed horseshoe sub-goals (`lem:horseshoe_twist`, `_dComp`,
  `_chainMap`, `_resolvesMiddle`) + the assembly `ofShortExact`.

## Per-target outcome (5 targets: 3 solved / 0 partial / 2 blocked / 0 untouched)

### SOLVED — `lem:horseshoe_dComp` (realized as `twistedBiprodD_comp`)
The matrix differential `[[d_K, τ],[0, d_L]]` squares to zero, built injective-free in the
top-level `TwistedBiprod` section. Key tactic friction: the first `rw` chain failed to match
`?f ≫ ?g + ?f ≫ ?g'` and a later `(?f ≫ ?g) ≫ ?h`; closed by inserting explicit
`Preadditive.add_comp` + two `Category.assoc` before `HomologicalComplex.d_comp_d`, then cancelling
the off-diagonal via `← Preadditive.comp_add, hτ n, add_neg_cancel`. The cocycle hypothesis `hτ`
is genuinely consumed (auditor-confirmed non-vacuous).

### SOLVED — `lem:horseshoe_chainMap` (realized as `twistedBiprodInl`/`twistedBiprodSnd`/`twistedBiprodSplitting` + `horseshoeSES_shortExact`)
The coprojection/projection chain maps + degreewise biproduct splitting, assembled into the
degreewise-split SES `0 → I_A → I_B → I_C → 0`. Gotcha: `CochainComplex.ofHom` only builds maps
*between two `CochainComplex.of` complexes*; a map from/to a general complex needs the structure
constructor with an explicit `comm'` (closed by `simp [twistedBiprod_d]`).

### SOLVED — `lem:horseshoe_twist` (realized as `horseshoeτ`, `horseshoeτ_cocycle`, `twistPair`, `horseshoeβ`)
The genuinely novel content: the off-diagonal twist family `τⁿ : I_C^n ⟶ I_A^{n+1}` by ℕ-recursion
(`twistPair` carries `(τⁿ, τⁿ⁺¹, cocycle)`), the cocycle `d_C^n ≫ τⁿ⁺¹ = -(τⁿ ≫ d_A^{n+1})`, and
the augmentation `β`. This target cost the bulk of the session and surfaced **three reusable
dead-ends** (now in the Knowledge Base):
1. Inside `namespace InjectiveResolution`, `Mono` of a *hypothesis* (`ses.f`) or of `I_C.ι.f n`
   FAILS to synthesize — even via `haveI`/`letI`/`by have` (6+ failed `lean_run_code` variants in
   the log). Fix: pass it positionally, `@Injective.factorThru _ _ _ _ _ (I_A.injective k) g f hMono`;
   for the resolution mono use `(mono_of_isLimit_fork I_C.isLimitKernelFork)`.
2. `rw [Preadditive.neg_comp]` (and friends) silently fail to match a `-hH` term *produced by a
   prior `rw`*; `simp only [neg_comp]` makes no progress and `simp [h]` leaves an unclosable
   `0 = 0`. Fix: prove the equality on a **fresh** goal then close with `exact` (defeq-tolerant);
   extract as a standalone lemma (`horseshoeτZero_hf`) since `rw` is erratic inside `def` bodies
   carrying unresolved universe metavariables.
3. `I_C.ι.f 0` has domain `((single₀).obj ses.X₃).X 0` — defeq but not *syntactically* `ses.X₃`;
   once composed under `ses.g`, the subterm no longer matches a standalone `I_C.ι.f 0 ≫ _`. Fix:
   the clean-domain wrapper `def ιC0 : ses.X₃ ⟶ I_C.cocomplex.X 0 := I_C.ι.f 0` (auditor-verified
   defeq via hover).

### BLOCKED — `lem:horseshoe_resolvesMiddle` (`ofShortExact_resolvesMiddle`) — the SOLE remaining P4 gap
`I_B` is an injective *resolution* of `B` iff `(single₀ B) ⟶ horseshoeMid` is a quasi-iso. The
clean approach is to transfer quasi-iso-ness across the SES of complexes from the outer resolution
augmentations. **Blocker (precise):** Mathlib provides only the **last-term** transfer
`quasiIso_τ₃` (`HomologySequenceLemmas.lean:168`); the **middle-term** `quasiIso_τ₂` is **ABSENT**
(the file docstring states only the four `τ₃` lemmas exist). The prover correctly declined to leave
half-built sorry-bearing code. This is not a route failure — it is a single, well-scoped new
objective: build `quasiIso_τ₂`/`isIso_homologyMap_τ₂` via the homology five-lemma on a 7-term LES
window spanning two `composableArrows₅` (plus the ℕ degree-0 boundary, handled as `τ₃` handles it).

### BLOCKED (downstream) — `lem:injective_resolution_of_ses` (`ofShortExact`)
All structural inputs exist; only the bundled `InjectiveResolution B` wrapper is missing, gated on
`resolvesMiddle`. Once it lands, the assembly to `rightDerivedShiftIsoOfAcyclic` and
`rightDerivedIsoOfAcyclicResolution` is straight-line off the already-proven
`rightDerivedShiftIsoOfSplitResolutionSES`.

## Headline finding — stale `\lean{...}` names would have permanently mis-fired `sync_leanok`
The planner's decomposition named the four sub-goals `ofShortExact_twist`/`_dComp`/`_chainMap`/
`_resolvesMiddle`. The prover correctly abstracted the injective-free core into a top-level
`TwistedBiprod` section and realized the twist content as a cluster, so three blueprint blocks
carried `\lean{...}` names that **no declaration has** (`lean_verify`: unknown constant). The
`sync_leanok` ran this iter (`sha 973bd6f`, `added: 2`) BEFORE the names were fixed, so it could
not mark `lem:horseshoe_twist`/`_dComp`/`_chainMap` `\leanok` even though their content is
complete and axiom-clean — and would never have, until the names were corrected. I corrected all
three `\lean{...}` hints (review-agent domain); next iter's `sync_leanok` will now detect these
three blocks as done. Caught independently by lean-vs-blueprint-checker (3 major).

## Subagent dispatches
- **lean-auditor** (`iter005`): dispatched (`.lean` modified this iter). **0 must-fix**, 1 major,
  6 minor. All 27+ decls non-vacuous and axiom-clean; workarounds sound (`ιC0` defeq confirmed);
  the iter-004 code-fence trap NOT reintroduced (the `-- def …ofShortExact` stub at L570 is
  doubly-commented and correctly listed as pending). Report:
  `task_results/lean-auditor-iter005.md`.
- **lean-vs-blueprint-checker** (`acyclic`): dispatched (file received prover work). 4 major
  (3 stale `\lean{}` names + 1 hand-waved `quasiIso_τ₂` gap in the `resolvesMiddle` sketch), 2 minor.
  0 sorry/placeholder red flags; all Lean code mathematically faithful. Report:
  `task_results/lean-vs-blueprint-checker-acyclic.md`.

(No `## Subagent skips` — both highly-recommended review subagents dispatched.)

## Blueprint markers updated (manual)
- `Cohomology_AcyclicResolution.tex`, `lem:horseshoe_twist`: corrected
  `\lean{...ofShortExact_twist}` → `\lean{...horseshoeτ, ...horseshoeτ_cocycle, ...horseshoeβ, ...twistPair}`
  (multi-target) + `% NOTE:` recording the cluster realization and recommending a block split.
- `Cohomology_AcyclicResolution.tex`, `lem:horseshoe_dComp`: corrected
  `\lean{...ofShortExact_dComp}` → `\lean{CategoryTheory.twistedBiprodD_comp}` + `% NOTE:` (injective-free `TwistedBiprod` abstraction).
- `Cohomology_AcyclicResolution.tex`, `lem:horseshoe_chainMap`: corrected
  `\lean{...ofShortExact_chainMap}` → `\lean{...twistedBiprodInl, ...twistedBiprodSnd, ...twistedBiprodSplitting, ...horseshoeSES_shortExact}` + `% NOTE:`.
- `Cohomology_AcyclicResolution.tex`, `lem:horseshoe_resolvesMiddle`: added `% NOTE:` that this is
  the sole remaining gap and is harder than the LES-vanishing prose suggests — needs the
  Mathlib-absent `quasiIso_τ₂`; planner should scaffold it as a new leaf.
- Did **not** touch `\leanok` (sync_leanok's domain). Did not add `\mathlibok` (the 6 Mathlib
  anchors already carry it, verified faithful by the checker). The false `\leanok` on
  `lem:injective_resolution_of_ses` is sync_leanok's to strip once the code-fence trap clears (the
  refactor already fixed the fence in iter-005's plan phase).

## Low-severity notes
- lean-auditor major: the 177-line `/-! ### Status (iter-005) … -/` block (L457–633) embeds
  strategy/planner content in the Lean source and is the source of all long-line warnings — belongs
  in `.archon/` state, not the `.lean` file. Minor: 4 unused-section-variable warnings (fixable via
  `omit [HasInjectiveResolutions 𝒜] in`); module docstring lists undeclared future targets.
- blueprint-doctor: **no structural findings** (all chapters `\input`'d, all refs resolve, no new
  axioms).

## Recommendations for next session
See `recommendations.md`. Headline: scaffold `quasiIso_τ₂`/`isIso_homologyMap_τ₂` as a new provable
leaf — it is the single thing gating the entire P4 tail.
