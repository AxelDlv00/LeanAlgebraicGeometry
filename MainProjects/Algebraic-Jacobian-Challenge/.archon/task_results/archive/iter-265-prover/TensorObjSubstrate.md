# AlgebraicJacobian/Picard/TensorObjSubstrate.lean — iter-265 (fine-grained, D3′ Sq1 tail)

Objective 2: STEP 1 = extract the presheaf↔sheaf compatibility bridge as a named lemma and prove
it axiom-clean; STEP 2 = assemble `sheafificationCompPullback_comp_tail` (a)–(e).

## Sentence 1 — STEP-1 binding-obligation bridge → `forget_map_pushforward_map`
- **Type:** `(SheafOfModules.forget S).map ((SheafOfModules.pushforward φ).map g) =
  (PresheafOfModules.pushforward φ.hom).map ((SheafOfModules.forget R).map g)` for a general
  continuous-functor sheaf-ring morphism `φ` and a sheaf-of-modules morphism `g`.
- **Result:** **RESOLVED — axiom-clean (`rfl`).** Verified via `lean_verify`: axioms =
  `{propext, Classical.choice, Quot.sound}`, **no `sorryAx`**.
- **Why it's `rfl`:** `SheafOfModules.pushforward` is defined sectionwise from
  `PresheafOfModules.pushforward` (`@[simps map_val]` ⇒ `pushforward_map_val`), and
  `SheafOfModules.forget` is the `.val` projection (`forget_map`); the two sides are definitionally
  equal. Exactly the planner's expectation ("likely near-definitional").
- This is the precise blocker the iter-264 prover named (the presheaf↔sheaf forget/pushforward
  compatibility bridge feeding the recovered units). **It is the sanctioned measurable decompose
  deliverable for this iteration.**

## Sentence 2 — wire the bridge into the tail (blueprint step (d)) → in-proof `erw`
- **Result:** **RESOLVED (structural).** `erw [forget_map_pushforward_map]` *fires* on the tail goal
  and rewrites the second RHS factor `forget.map ((SheafOfModules.pushforward φ_{h≫f}).map (R1≫R5≫δ))`
  to the presheaf-level `(PresheafOfModules.pushforward φ'_{h≫f}).map (forget.map (R1≫R5≫δ))`,
  crossing the sheaf↔presheaf boundary.
- **Finding:** plain `rw [forget_map_pushforward_map]` does NOT fire (defeq-not-syntactic
  `SheafOfModules.pushforward`/`forget` composite) — **`erw` is required**, confirming the bridge is
  genuinely the needed device, not cosmetic.

## Sentence 3 — split RHS first factor (blueprint step (e.0)) → in-proof `rw [Functor.map_comp]`
- **Result:** **RESOLVED (structural).** `rw [Functor.map_comp]` (PLAIN, not `erw`) splits
  `forget.map (B'_unit ≫ pushforwardComp.hom)` into `forget.map B'_unit ≫ forget.map pushforwardComp.hom`
  without touching the LHS.
- **Finding (recorded in-file):** an `erw` here instead matches the LHS
  `pushforward.map (sheafAdj_Z.unit.app _)` by defeq and UNFOLDS the unit into its
  `toSheafify ≫ restrictHomEquivOfIsLocallySurjective` expansion — the exact contamination the
  iter-262 R0-peel comment warned about one square up. Plain `rw` is the safe choice.

## Sentence 4 — R1/R5 recovery + slide (blueprint steps (ii)–(iii)) → `sorry` (BLOCKED)
- **Result:** **PARTIAL / sorry with precise blocker.** Remaining goal documented in-file:
  `B_{h≫f}.unit P = a_X.unit P ≫ (forget.map B'_unit ≫ forget.map pushforwardComp.hom)
   ≫ pushforward φ'_{h≫f}.map (forget.map (R1 ≫ R5 ≫ δ_pre))`.
- **Exact blocker:** recovering R1/R5 as the composite-adjunction units `B_f.unit`/`B_h.unit` needs a
  `have` that reframes `forget.map ((pullback h).map (sheafCompPb f .app P).hom)` through the
  f-adjunction `homEquiv` (the twin of the model's `hinner` L952–973 in
  `pullbackObjUnitToUnit_comp`), so that `leftAdjointUniqUnitEta_app` (axiom-clean, L1668) can fire.
  The bare goal has no `homEquiv` head. The `unitToPushforwardObjUnit`-analog at the
  composite (sheafify∘pushforward) adjunction level is **absent** — in the model it was `rfl`
  (`unitToPushforwardObjUnit_comp`), here the units are composite adjunctions so it is NOT `rfl`. This
  is the genuinely-novel sheafification-laden mate step.
- Next: `leftAdjointUniqUnitEta_app` recovery → slide `(SheafOfModules.pushforwardComp h f).hom` past
  via `.hom.naturality` → collapse `Adjunction.comp_unit_app` + `Adjunction.unit_naturality` to
  `B_{h≫f}.unit` (model L997–1001).

## Assembly (`sheafificationCompPullback_comp_tail`)
- Proof body now: `rw [restrictScalarsId_map]; conv_rhs => rw [Functor.map_comp]` (DONE iter-264) →
  `erw [forget_map_pushforward_map]` (step d, NEW) → `rw [Functor.map_comp]` (step e.0, NEW) → `sorry`.
- Compiles. Caller `sheafificationCompPullback_comp` unchanged (signature of tail unchanged).

## Summary
- **3/4 sentences closed** (the bridge axiom-clean + two structural wiring steps committed and
  compiling); 1 open (R1/R5 recovery).
- **Sorry count: 3 → 3** (file-level unchanged) BUT **+1 new axiom-clean named sub-lemma**
  (`forget_map_pushforward_map`) — the pc265-sanctioned measurable decompose deliverable. The tail
  `sheafificationCompPullback_comp_tail` advanced from `…conv_rhs; sorry` to
  `…conv_rhs; erw [bridge]; rw [map_comp]; sorry` (2 committed steps consumed).
- Other sorries untouched: L720 `exists_tensorObj_inverse` (gated), L~2858 `pullbackTensorMap_restrict`
  (gated). No protected signatures touched. File compiles (no errors), RACE-safe for DualInverse.lean.

## Why I stopped
- **Real progress:** sentence 1 (`forget_map_pushforward_map`) closed axiom-clean — the explicit
  STEP-1 deliverable. Sentences 2–3 closed as committed compiling tactic steps (bridge wired in +
  RHS factor split), each with a recorded defeq/contamination finding.
- **Partial progress:** sentence 4 (R1/R5 recovery) is the residual. Exact blocker is NOT "it's
  hard": it is the absence of a `homEquiv`-framing `have` (model `hinner` twin) at the composite
  sheafify∘pushforward-adjunction level, which is the genuinely-novel non-`rfl` mate step the planner
  flagged for possible escalation. Per the bar, the STEP-1 bridge being landed axiom-clean is the
  sanctioned measurable outcome; the assembly's remaining (ii)–(iii) are concretely specified in-file.
- **Recommended next:** a `prove` pass building the `hinner`/`hcomp'` twins as `have`s using
  `leftAdjointUniqUnitEta_app` + `Adjunction.homEquiv_naturality_*`, OR — if it stalls a 6th time —
  the planner-sanctioned cross-domain analogist on the bicategorical-cocycle shape (the bridge is now
  in hand, so the remaining work is genuinely the novel mate calculus, not under-specification).

## Blueprint markers
- `lem:` for the new bridge: the blueprint's `lem:pullback_tensor_map_basechange` Sq1-tail
  binding-obligation paragraph is now realized by `forget_map_pushforward_map` — ready for the
  reviewer to add a `\lean{...}` hint / `\leanok` (handled by deterministic `sync_leanok`).
