# Recommendations — for the iter-219 plan agent

## TOP — the reversal signal fired; pivot to infrastructure scoping, do NOT re-prove

The iter-218 PRIMARY (`exists_tensorObj_inverse`) hit the pre-committed INCOMPLETE gate:
genuinely Mathlib-absent primitive, blocked at step 1 (cannot name the dual `Linv`). The plan
agent's own cheapest-reversal-signal said this triggers a **mathlib-analogist** round, NOT a
blind re-dispatch of `prove`. Honor it.

1. **[CRITICAL] Run `mathlib-analogist` (api-alignment) on the `SheafOfModules` dual / internal-hom.**
   - Question: does Mathlib at `b80f227` have any path to
     `dual M : X.Modules := ℋom_{𝒪_X}(M, 𝒪_X)` and `eval : tensorObj M (dual M) ⟶ unit`, or to a
     presheaf-level internal hom on `PresheafOfModules R` that can be sheafified (mirroring how
     `tensorObj` sheafifies the presheaf tensor)? If not, what is the smallest bespoke build?
   - This is the progress-critic ts218 PRE-CAUTION trigger (scheduled before iter-220). The full
     decomposition and the two candidate primitives (I = dual+eval; II = object-level descent) are in
     `informal/exists_tensorObj_inverse.md`. Pass that file to the analogist.
   - Do NOT push a `dual`-shaped helper-sorry into `exists_tensorObj_inverse` (iter-214 d.1 anti-pattern).

2. **[CRITICAL] Do NOT re-assign `exists_tensorObj_inverse` or `isLocallyInjective_whiskerLeft_of_W`
   to a `prove` round.** Both are blocked on new infrastructure, not on proof search:
   - `exists_tensorObj_inverse` ← object-level internal-hom/dual for `SheafOfModules` (absent).
   - `isLocallyInjective_whiskerLeft_of_W` (L632) ← stalk d.2 (varying-ring stalk-⊗, absent) OR
     morphism-level `SheafOfModules` descent (absent). Re-proving either is guaranteed churn.

## Two Mathlib-absent infrastructure families now gate the whole Lane-TS critical path

After this iter the lane bottoms out on **two** "build new Mathlib infra" tasks, both confirmed
absent at `b80f227`:
- **(A) object-level** internal-hom/dual + evaluation for `SheafOfModules` → unblocks the inverse →
  unblocks the iso-class `CommGroup` → unblocks `addCommGroup_via_tensorObj` (RPF consumer).
- **(B) morphism-level descent** (glue local isos into a global one) / stalk-⊗ commutation d.2 →
  unblocks the assoc re-route + the vestigial-deletion −1, and would close L632.

This is a strategy-level moment: the lane's remaining work is now **infrastructure-build**, not
proof-fill. If the analogist (item 1) returns "buildable but multi-iter," the planner should weigh
that cost against the standing USER RR-fork (still unresolved) and consider surfacing it. The
strategy-critic was skipped iter-217/218 on "intra-route bookkeeping" grounds; once the analogist
returns an infra-cost estimate, **re-dispatch strategy-critic** — the route's character has shifted
from "close the inverse" to "fund a Mathlib internal-hom build," which is a strategic question.

## `tensorObj_assoc_iso` is NOT axiom-clean (correction for the project narrative)

Both review subagents confirm `tensorObj_assoc_iso` transitively depends on the L632 `sorry` via
`W_whiskerLeft/Right_of_W`. The "associator ASSEMBLED, no sorry in its body" framing (iter-214) is
literally true but the existence-of-associator the group law consumes is **still gated on L632**.
Treat the associator as NOT-yet-closed for planning. The sorry-free gluing rewrite the blueprint
describes is blocked on (B) above.

## Blueprint must-fix already partially actioned by review (`% NOTE`s added) — finish via a writer

lean-vs-blueprint-checker ts218 raised a MUST-FIX and a MAJOR on the chapter; I added `% NOTE`
annotations to both proof blocks this review (see summary "Blueprint markers updated"). For a clean
chapter the iter-219 planner should dispatch a **blueprint-writer** on `Picard_TensorObjSubstrate.tex` to:
1. rewrite the `lem:tensorobj_inverse_invertible` proof prose from present-constructive to
   "intended route; Lean body `sorry`, blocked on absent internal-hom — see
   `informal/exists_tensorObj_inverse.md`" (my `% NOTE` flags it; the prose still reads as executable);
2. annotate `lem:tensorobj_assoc_iso` that the current Lean proof uses the whiskering route (transitive
   sorry), and the gluing prose is the intended rewrite;
3. retract the "Lean declaration removed in iter-218" wording on the `% SUPERSEDED` whiskering/stalk
   blocks — those declarations are STILL PRESENT and `tensorObj_assoc_iso` still calls them.
   The HARD GATE next iter will re-flag the chapter as `partial` on the inverse block until (1) lands.

## `.lean` docstring staleness (lean-auditor ts218 majors) — fold into the next prover ride-along
- `tensorObjOnProduct` (L1406) docstring falsely says "typed `sorry`" — body is complete (uses
  `tensorObj_isLocallyTrivial`). Correct it.
- `tensorObj_assoc_iso` docstring (L1107-1149) describes the superseded FLAT route + "iter-212 typed
  sorry" — proof is closed via ROUTE (d); correct to ROUTE (d) and note the transitive L632 dep.
- Module header "Status (iter-202)" block (L37-86) is 16 iters stale (claims all 4 pinned decls carry
  sorry; 3 are closed). Rewrite.
- These are cosmetic (no sorry impact) — bundle as ride-along cleanup the next time a prover legitimately
  opens this file; do NOT spend a dedicated prover round on them.

## Dead code (informational — do NOT delete yet)
`isLocallyInjective_whiskerLeft_of_flat`, `W_whiskerLeft_of_flat`, `W_whiskerRight_of_flat` (flat
cluster) and `stalkLinearMap`/`_germ`/`_bijective_of_isIso`/`stalkLinearEquivOfIsIso` (stalk cluster)
have zero live proof consumers. Deletion gives **zero sorry-progress** (the L632 sorry is in the LIVE
`_of_W` chain) and only risks the build — bundle it with the assoc re-route once (B) is unblocked.

## Reusable patterns (no change this iter)
- The iter-217 `tensorObj_restrict_iso` recipe (4-step composite + H1/H2 + the 3 gotchas) remains the
  top Proof-Patterns entry and is the template for any future presheaf-then-sheafify internal-hom build.
