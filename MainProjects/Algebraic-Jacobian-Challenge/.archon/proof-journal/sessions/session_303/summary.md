# Session 303 — review of iter-303

**First prover round after 31 consecutive DAG/blueprint iters (272–302).** The four
lanes executed the iter-271 correctives (devised but never actually run) for the
first time. Four files received prover edits; all touched files compile (`lake env
lean` EXIT 0) with only `sorry`/long-line warnings; every newly-landed declaration is
axiom-clean `{propext, Classical.choice, Quot.sound}`.

- Global sorry count (grep, AlgebraicJacobian/**): **~102** (no net regression).
- Blueprint doctor: **no structural findings** (all chapters `\input`'d, all refs
  resolve, no `axiom` decls).
- `archon dag-query unmatched`: **9 new `lean_aux` nodes** (all this session's
  helpers) — listed in recommendations.md for the planner to blueprint.

## Lane-by-lane

### Lane A (ENGINE) — `Cohomology/CechHigherDirectImage.lean`, `pushPullMap_comp` — PARTIAL (dominant pole, 5th iter)

The 5-iter **kernel-`whnf` wall** (iters 264/265/271 blocker — `eqToHom`
over-triangle transports blowing up the kernel) is **genuinely removed**. Route:
- `rawPushPullMap` — scheme-level push–pull map with the over-triangle `w : a ≫ p₁ =
  p₂` as a **free hypothesis** (so it can be `subst`'d). Axiom-clean.
- `pushPullMap_eq_raw` — `pushPullMap F g = rawPushPullMap g.left … (Over.w g) F` by
  `rfl` (needs `set_option maxHeartbeats 1000000`).
- `pushPull_unit_comp`, `pushforwardComp_hom_app_id` — composite-unit decomposition
  and the fact that pushforward is **strict** (`pushforwardComp.hom.app = 𝟙` by
  `rfl`). Both axiom-clean.

After `subst wg; subst wh` every transport becomes `eqToHom rfl = 𝟙` and vanishes
(kernel-cheap). The goal reduces to the genuine **pullback pseudofunctor pentagon** =
`Scheme.Modules.pseudofunctor_associativity (f:=b) (g:=a) (h:=p₁)` (its four
`pullbackComp` cells match exactly).

**Not closed.** The residual regime is *defeq-not-syntactic*:
- `rw`/`reassoc_of%`/`pseudofunctor_associativity` **fail to match** visually-identical
  terms (non-syntactic `SheafOfModules` instances on `≫`/`.map`).
- `erw` matches but **whnf-unfolds `pullbackComp`** into its raw
  `TwoSquare.equivNatTrans`/`mateEquiv` mate definition → goal explodes.
- `congr 1` on the leading factors recurses into the functor structure and produces
  `HEq` goals.
- `rawPushPullMap_comp` **kernel-timeouts even at `maxHeartbeats 4000000`**
  (`(kernel) deterministic timeout`), so both `rawPushPullMap_comp` and the
  `pushPullMap_comp` wrapper were **commented out**, leaving the 4 axiom-clean bricks
  plus a detailed in-file reduction note (lines 438–477).

Net: real structural advance (wall removed, blocker shifted from kernel→syntactic),
but the dominant pole is still open. See milestones for the two documented next
routes (adjunction-transpose reformulation; strictness-aware simp normal form).

### Lane 1 (DUAL) — `Picard/TensorObjSubstrate/DualInverse.lean`, `sliceDualTransportInv` — PARTIAL (1 sorry closed, 6→5)

**`sliceDualTransportInv.app` is now FULLY CLOSED axiom-clean** — the ~100-LOC
instance-delicate reverse component that drove the iter-265→302 DUAL churning. It is
the explicit four-leg composite:
1. source relabel `M.val.map (eqToHom (op he.symm))` (semilinear, codomain restricted
   along `ρ = X.ringCatSheaf.map (eqToHom …)`);
2. ψ-reindex `restrictScalars (f.appIso (f⁻¹ᵁW')).hom ∘ ψ.app`;
3. codomain unit swap `dualUnitRingSwapHom f (f⁻¹ᵁW')`;
4. cross-fiber transport closed by `?collapse` = `restrictScalarsId'App ∘
   restrictScalarsComp'App` and `?unit` = new helper `unitRelabelSwap`.

**Key enabler:** the abstract dual map needed a **β-compatibility hypothesis** `hβ : ∀
P, (β.app (op P)).hom.comp (f.appIso P).hom = RingHom.id …` (abstractly false; the
prover added it as a binder and discharged it at the call site for the specific `β =
whiskerRight (f.appIso).inv` via `Iso.hom_inv_id`). Two new top-level helpers:
`unitRelabelSwap` and `isIso_ε_restrictScalars_presheafMap` (ε phrased at the
`X.presheaf` CommRingCat carrier so `CommRing` is native).

Remaining DualInverse holes (5): reverse-component **naturality** (now reachable — the
square is over a thin poset and `app` is an explicit composite), the forward
`sliceDualTransport.hom`, and `dual_restrict_iso` Step-4 `isoMk` naturality.

### Lane (Generic flatness) — `Picard/FlatteningStratification.lean` — PARTIAL + signature defect surfaced

Three axiom-clean **algebraic generic-freeness** lemmas (finite-morphism case) landed
as a Mathlib supplement: `GenericFreeness.exists_free_localizationAway_of_finite`,
`exists_flat_localizationAway_of_finite`, `exists_free_localizationAway_of_moduleFinite`
— all via `Module.FinitePresentation.exists_free_localizedModule_powers` +
`Module.Flat.of_free`. (`unknown universe level v` fixed by `Type*` binders.)

**Critical finding (broadened by reviewers):** the geometric `genericFlatness` Lean
signature is **defective** — `F : X.Modules` carries **no coherence / finite-type
hypothesis**, so it is **FALSE as written** and its `sorry` unprovable. The
`lean-vs-blueprint-checker` pass found this is **systemic: 7 declarations** in this file
share the defect (`genericFlatness`, `flatLocusStratification`, `flatLocusReduction`,
`flatLocusAssembly`, `flatteningStratification`, `flatteningStratification_universal`,
`flatteningStratification.ofCurve`). Mathlib has no `IsCoherentSheaf` for
`Scheme.Modules`, so a **project-local coherence predicate** must be defined and added to
all seven; the chapter prose is also inadequate (no Lean typeclass guidance). None are
protected → planner re-signs. I added a `% NOTE:` to the blueprint block. (See
recommendations CRITICAL 1.)

## Review subagents

- `lean-auditor/iter303` — 0 must-fix, 6 major, 6 minor; no excuse-comments / axiom
  abuse. Report: `.archon/task_results/lean-auditor-iter303.md`.
- `lean-vs-blueprint-checker/flattening303` — 7 must-fix coherence defects + 3
  blueprint-coverage gaps. Report:
  `.archon/task_results/lean-vs-blueprint-checker-flattening303.md`.

### Lane 2 (D3′) — `Picard/TensorObjSubstrate.lean` — marginal

The objective's named "ready tensor-iso nodes" (`jw_ismonoidal`,
`pullback0_tensor_iso`, `pullback_tensor_iso_loctriv`,
`pullback_compatible_with_tensorobj`, `stalk_tensor_commutation_naturality_right`) **do
not exist as Lean declarations** — they are blueprint-pinned statements only. The
actionable target was the D3′ `sheafificationCompPullback` comp tail; only one
documented forward step landed (RHS composite-unit expansion via
`Adjunction.comp_unit_app`; `aesop_cat` does not close). The tail is a project-local
6-step mate calculus over Mathlib-absent coherence — effectively blocked.

## Blueprint markers updated (manual)

- `Picard_FlatteningStratification.tex`, `thm:generic_flatness`: added `% NOTE:`
  flagging the Lean↔blueprint signature mismatch (`genericFlatness` lacks the coherent
  / finite-type hypothesis; sorry unprovable; planner must re-sign — not protected).

No `\mathlibok` added (no Mathlib re-export decls this session — the new
`GenericFreeness.*` lemmas are project proofs that *consume* Mathlib, not aliases). No
`\lean{...}` renames flagged. No stale `\notready` to strip. `\leanok` untouched
(sync_leanok ran at iter-271 per `sync_leanok-state.json`; note its `iter` is 271 < 303,
so `\leanok` markers may be stale — flagged in recommendations, not raised as CRITICAL).

## Notes (LOW)

- `lean_verify` confirmed `{propext, Classical.choice, Quot.sound}` on the new decls.
- `archon-informal-agent` (Kimi via `MOONSHOT_API_KEY`) was consulted once for the
  generic-freeness route; it pointed at the Noether-normalization+content argument for
  the full finite-type case (not formalized — only the finite case landed).
