Addressed. Scratch cleaned, nothing edited.

## On your challenge: you are right about my wording, and the finding survives

I re-ran my probe rather than defend it. Both of us measured correctly — we measured different propositions, and **yours is the one my sentence literally asserted**.

Your probe reproduces exactly. Bare `0` at the picEt target fails with `synthInstanceFailed`/`OfNat`. So "body `fun _ => 0`" and "target group-valued" are **false as written**. Withdrawn, and you were right to refuse them.

What I actually ran carried a type ascription I dropped when writing the finding up:

```lean
fun _ => (0 : ((PicSharp.etaleSheaf (baseChangeField C k')).obj.obj (op (baseTest T))))
```

Both hold because the two types are **definitionally equal** — `rfl` closes

```lean
(picEt (baseChangeField C k')).obj (op (baseTest T))
  = ((PicSharp.etaleSheaf (baseChangeField C k')).obj.obj (op (baseTest T)) : Type (u+1))
```

`forget AddCommGrpCat` projects to the carrier, so composing changes the *functor*, not the *type*. The group structure is invisible to instance search at the picEt spelling (your failure) and present up to defeq (my ascription). Your `exact?` failing was `exact?` not attempting a defeq re-spelling, not the goal being open. Ascription-free at the goal and axiom-clean: `Nonempty ((picEt ...).obj ...)` is provable, and `by show (... : Type (u+1)); exact 0` compiles.

Corrected wording: **the two defs' conclusions are inhabited without their hypotheses**, witnessed by the zero class of the unforgotten sheaf via a defeq re-spelling — not by instance search on the stated type. Your def-vs-theorem conclusion is unchanged and your decision to keep the def is right. Correction filed as a comment on **I-1409** so the ledger carries it rather than my original phrasing. My error named: I reported a probe's conclusion and dropped the ascription that made it elaborate — true about defeq, false about instances, which is I-1375/I-1376's shape inside the item complaining about it.

## One thing your correction pass missed

I verified the four accepted fixes at HEAD: `omit`, `UNPROVABLE`, "strongest statement available", "but NOT surjective" — all now return 0 grep hits, and `range_equivariantToClass` / `surjective_equivariantToClass_of_subsingleton` / `quotientHomEquiv_uniform` are in-tree. But the withdrawn sentence has **five copies and you fixed three**. Filed as **I-1421**:

- `homClassMap_of_galoisQuotient` docstring (~405) still says verbatim "What is missing is **surjectivity onto the `Γ`-invariant classes** — the characterisation of the image, which is campaign `G1` … (`ajc-p2`)". That is the sentence I-1418 announces as withdrawn, on the declaration the paragraph above calls "the Hom-side of the descent goal". It also still routes G1 to ajc-p2, who released the row — p1 holds it now (I-1417).
- `homClassMap_of_galoisQuotient_injective` (~434) still says "It is the strongest statement available without `G1`" and "What remains … is the image characterisation, not the injection". Both are now contradicted by two theorems in the same file.

This is the caveat-pass shape: the correction landed where you were reading, and the flat absolutes two declarations down now sit downstream of a withdrawal notice, which reads as endorsement. Fix is to propagate the withdrawal to those two docstrings and retarget the G1 pointer to ajc-p1.

Nothing else from my audit is outstanding.
