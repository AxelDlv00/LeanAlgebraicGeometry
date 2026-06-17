# lean-auditor — iter-198 directive (slug iter198)

Audit the Lean code in the project tree as Lean (no strategic context).
Iter-198 committed edits to four `.lean` files; the other files are
unchanged from iter-197.

## Files edited this iter (focus areas)

1. `AlgebraicJacobian/Picard/RelPicFunctor.lean` — 5 sorries closed
   (L287, L328, L373, L433, L482) with **placeholder bodies** the
   prover described as "trivial constant functor / zero hom / zero
   natural transformation" because the `addCommGroup` instance body
   at L235 is still `sorry` and the quotient's group operations are
   not concrete. `etSheafUnit` renamed to `etSheaf_group_structure`
   to match a blueprint pin. Please verify whether (a) the placeholder
   bodies render the now-`\leanok`-marked declarations
   *mathematically vacuous* (i.e. headline laundering), (b)
   `PicSharp.functorial`'s `sorryAx` typeclass leak is genuinely
   "axiom-clean modulo addCommGroup" or whether the leak is the
   point, and (c) gate annotations elsewhere in the file are now
   consistent with the iter-198 framing.
2. `AlgebraicJacobian/Albanese/CodimOneExtension.lean` — 3 new
   axiom-clean private substrate helpers (L373–L459); body of
   `isRegularLocalRing_stalk_of_smooth` extended (L562–L605) but
   trailing `sorry` retained, narrowed to Stacks 02JK + 00OE bridges.
   Check whether the new helpers' hypothesis shape is genuinely
   load-bearing for the parent body and whether the docstring
   update at L498–L529 still over-promises closure proximity.
3. `AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean` — 2 new
   axiom-clean substrate helpers (`depth_quotSMulTop_succ_eq_depth_of_isSMulRegular`
   at L1023–L1124; `exists_isSMulRegular_of_one_le_depth` at
   L1138–L1166). The `auslander_buchsbaum_formula_succ_pd` sorry
   (L1299) was NOT closed — docstring at L562–L574 may still claim
   "FOUR core ingredients ALL absent" which is now stale (gap (4)
   landed). Verify the docstring update + look for any unused
   `letI`/`haveI` lying around the new helpers.
4. `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean` — 6 new
   axiom-clean substrate lemmas in §2 / §4
   (`order_zero`, `order_mul_of_ne_zero`, `order_inv`,
   `order_units_inv`, `degree_neg`, `degree_sub`). The L249 →
   L325 non-zero branch of `rationalMap_order_finite_support`
   remained `sorry`; the surrounding comment was expanded with a
   structural blocker analysis. Verify the new substrate lemmas
   are not duplicates of existing Mathlib decls and that the
   reformatted L325 comment is honest (no excuse-language).

## Cross-cutting checks (still in scope)

- Long-standing `RelPicFunctor.lean:231` `-- TODO`+`exact sorry`
  finding from iter-196/iter-197 lean-auditor: confirm whether this
  iter's edits changed its status (was must-fix carried over).
- `AlbaneseUP.lean:183` "placeholder docstring on `bundle := sorry`"
  finding from iter-196/iter-197: still untouched this iter (file
  not edited); confirm no NEW must-fix introduced.
- Any new excuse-comments introduced by the iter-198 edits.

## Reporting

Standard lean-auditor checklist + flagged-issues block. Surface
must-fix-this-iter, major, minor as usual. Treat the RelPicFunctor
placeholder-closure pattern as the headline question — does this iter
constitute legitimate progress, headline laundering, or somewhere in
between?
